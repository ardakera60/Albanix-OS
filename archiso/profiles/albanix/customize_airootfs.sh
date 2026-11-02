#!/bin/bash
# customize_airootfs.sh — archiso hook run inside the CHROOT (live root) at
# build time. Configures the live system so it boots straight to SDDM in
# Albanian by default, and lays out the installed-system defaults that the
# Calamares installer later copies/adjusts.
#
# set -e : fail the ISO build if anything here fails.
set -euo pipefail

AIROOTFS="/"

log() { printf '[customize_airootfs] %s\n' "$*" >&2; }

# ---------------------------------------------------------------------
# 1. Locale: ONLY sq_AL.UTF-8 and en_US.UTF-8
# ---------------------------------------------------------------------
log "Configuring locales (sq_AL.UTF-8 + en_US.UTF-8 only)"
cat > /etc/locale.gen <<'EOF'
sq_AL.UTF-8 UTF-8
en_US.UTF-8 UTF-8
EOF
locale-gen

cat > /etc/locale.conf <<'EOF'
LANG=sq_AL.UTF-8
LC_COLLATE=C
LC_TIME=sq_AL.UTF-8
LC_NUMERIC=sq_AL.UTF-8
LC_MONETARY=sq_AL.UTF-8
LC_PAPER=sq_AL.UTF-8
LC_MEASUREMENT=sq_AL.UTF-8
LC_ADDRESS=sq_AL.UTF-8
LC_TELEPHONE=sq_AL.UTF-8
LC_NAME=sq_AL.UTF-8
EOF

# ---------------------------------------------------------------------
# 2. Console: Albanian keymap for the live ISO (X11/Wayland handled by KDE)
# ---------------------------------------------------------------------
cat > /etc/vconsole.conf <<'EOF'
KEYMAP=al
FONT=latarcyrheb-sun16
EOF

# ---------------------------------------------------------------------
# 3. Hostname
# ---------------------------------------------------------------------
echo "albanix-live" > /etc/hostname

# ---------------------------------------------------------------------
# 4. Issue / MOTD
# ---------------------------------------------------------------------
cat > /etc/issue <<'EOF'
Albanix OS \r (\l)
Gjuha parazgjedhje: Shqip (sq) / English (en)
Tastatura parazgjedhje: Shqiptare (al) + Anglisht (us), Alt+Shift perndryshon
Miresevini ne OS Albanix / Welcome to Albanix OS
EOF

cat > /etc/motd <<'EOF'
=================================================================
  Mirë se vini në Albanix OS / Welcome to Albanix OS
  KDE Plasma 6  |  Wayland (X11 fallback)  |  sq_AL.UTF-8 default
  Live user: albanix  (password: albanix)  |  root: locked
  Install: run 'calamares' from the menu or terminal.
  No telemetry. No ads. No tracking.
=================================================================
EOF

# ---------------------------------------------------------------------
# 5. Live user autologin to SDDM (albanix / albanix)
# ---------------------------------------------------------------------
log "Setting up SDDM autologin for live user 'albanix'"
useradd -m -G wheel -s /bin/zsh albanix 2>/dev/null || true
echo 'albanix:albanix' | chpasswd
# Lock root password on the live ISO (sudo only via wheel NOPASSWD for live).
passwd -l root 2>/dev/null || true

# wheel NOPASSWD for the live user (convenience on live ISO only;
# the installed system gets sane sudo via Calamares users module).
mkdir -p /etc/sudoers.d
echo 'albanix ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/99-albanix-live
chmod 0440 /etc/sudoers.d/99-albanix-live

# SDDM autologin + Albanian keyboard + theme placeholder (red default).
mkdir -p /etc/sddm.conf.d
cat > /etc/sddm.conf.d/albanix.conf <<'EOF'
[Autologin]
Relogin=false
Session=plasmawayland
User=albanix

[Theme]
# Theme is set by albanix-theme-switcher at first boot based on
# the kernel cmdline parameter albanix.theme=red|blue (default red).
Current=

[General]
HaltCommand=/usr/bin/systemctl poweroff
RebootCommand=/usr/bin/systemctl reboot

[Users]
MaximumUid=60000
MinimumUid=1000

[Wayland]
EnableHiDPI=true
EOF

# ---------------------------------------------------------------------
# 6. Enable services that should run on the live ISO and by default
#    on installed systems (Calamares enables the rest).
# ---------------------------------------------------------------------
log "Enabling default systemd services"
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups
systemctl enable sddm
systemctl enable fstrim.timer
systemctl enable systemd-oomd
systemctl enable power-profiles-daemon
systemctl enable ananicy-cpp
systemctl enable thermald 2>/dev/null || true
systemctl enable reflector.timer
systemctl enable snapper-timeline.timer 2>/dev/null || true
systemctl enable snapper-cleanup.timer 2>/dev/null || true
systemctl enable snapper-boot.timer 2>/dev/null || true

# ---------------------------------------------------------------------
# 7. zram generator: zstd, sized by RAM
# ---------------------------------------------------------------------
mkdir -p /etc/systemd/zram-generator.conf.d
cat > /etc/systemd/zram-generator.conf.d/albanix.conf <<'EOF'
[zram0]
zram-size = min(ram, 8192)
compression-algorithm = zstd
EOF

# ---------------------------------------------------------------------
# 8. sysctl performance tuning (CachyOS-inspired, one-line reasons)
# ---------------------------------------------------------------------
cat > /etc/sysctl.d/99-albanix-performance.conf <<'EOF'
# vm.swappiness=10 : prefer keeping app memory, swap only under pressure.
vm.swappiness = 10
# vm.vfs_cache_pressure=200 : reclaim page cache sooner under memory pressure.
vm.vfs_cache_pressure = 200
# Dirty writeback: start writing back at 10%, force at 30% (SSD-friendly).
vm.dirty_ratio = 30
vm.dirty_background_ratio = 10
vm.dirty_expire_centisecs = 3000
vm.dirty_writeback_centisecs = 500
# kernel.watchdog throttle: reduce NMI watchdog noise on laptops.
kernel.watchdog = 0
# Scheduler: slightly more aggressive wakeup granularity for interactivity.
kernel.sched_min_granularity_ns = 10000000
kernel.sched_wakeup_granularity_ns = 2000000
# Network: TCP BBR + fq (better throughput/latency on WAN).
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
# File watchers: plenty for IDEs / node / rust tooling.
fs.inotify.max_user_watches = 524288
fs.inotify.max_user_instances = 512
EOF

# ---------------------------------------------------------------------
# 9. AppArmor: enforce by default on installed systems; complain on live ISO.
# ---------------------------------------------------------------------
# (Installed system switching done in Calamares shellprocess phase.)

# ---------------------------------------------------------------------
# 10. Timezone / NTP presets for the live ISO (Albania default).
# ---------------------------------------------------------------------
ln -sf /usr/share/zoneinfo/Europe/Tirane /etc/localtime
timedatectl set-ntp true 2>/dev/null || true
hwclock --systohc --utc 2>/dev/null || true

# ---------------------------------------------------------------------
# 11. Mark the live environment
# ---------------------------------------------------------------------
touch /etc/albanix-live

log "customize_airootfs done"
