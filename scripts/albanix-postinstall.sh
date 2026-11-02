#!/bin/bash
# albanix-postinstall.sh — Calamares shellprocess post-install script
# Runs inside the CHROOT (target system) at the end of installation, before reboot.
# Applies timezone + NTP, enables services, runs CPU-based repo selection,
# applies the chosen theme, creates the baseline Btrfs snapshot, removes
# installer leftovers.
#
# This file is installed by albanix-installer-config to
# /usr/share/calamares/scripts/albanix-postinstall.sh and referenced from
# calamares/modules/shellprocess.conf.
set -euo pipefail

TARGET="${1:-/}"
log() { printf '[albanix-postinstall] %s\n' "$*" >&2; }

# Read the theme choice left by the custom Calamares theme-choice module.
THEME_FILE="${TARGET}/var/lib/calamares/albanix-theme"
THEME="red"
if [[ -f "${THEME_FILE}" ]]; then
  THEME="$(cat "${THEME_FILE}")"
fi
log "Applying theme: ${THEME}"

# ---------------------------------------------------------------------
# 1. Timezone + NTP (already set by Calamares localecfg/hwclock; enforce)
# ---------------------------------------------------------------------
log "Setting timezone Europe/Tirane and NTP"
arch-chroot "${TARGET}" timedatectl set-timezone Europe/Tirane
arch-chroot "${TARGET}" timedatectl set-ntp true

# ---------------------------------------------------------------------
# 2. Enable core services
# ---------------------------------------------------------------------
log "Enabling core systemd services"
for svc in NetworkManager bluetooth cups sddm fstrim.timer systemd-oomd \
           power-profiles-daemon ananicy-cpp thermald reflector.timer \
           snapper-timeline.timer snapper-cleanup.timer snapper-boot.timer; do
  arch-chroot "${TARGET}" systemctl enable "${svc}" 2>/dev/null || true
done

# ufw: enable with secure defaults (deny incoming, allow outgoing)
arch-chroot "${TARGET}" ufw default deny incoming
arch-chroot "${TARGET}" ufw default allow outgoing
arch-chroot "${TARGET}" ufw enable
arch-chroot "${TARGET}" systemctl enable ufw

# ---------------------------------------------------------------------
# 3. CPU-based optimized repo selection (fast path — opt-in trust)
# ---------------------------------------------------------------------
log "Running CPU-based repo selection (albanix-repo-select)"
arch-chroot "${TARGET}" albanix-repo-select || \
  log "WARNING: albanix-repo-select failed; keeping generic Arch repos."

# ---------------------------------------------------------------------
# 4. Apply the chosen theme to the installed system
# ---------------------------------------------------------------------
log "Applying Albanix theme ${THEME}"
arch-chroot "${TARGET}" albanix-theme "${THEME}" || \
  log "WARNING: albanix-theme ${THEME} failed."

# ---------------------------------------------------------------------
# 5. Create baseline Btrfs snapshot (@)
# ---------------------------------------------------------------------
log "Creating baseline Btrfs snapshot"
if arch-chroot "${TARGET}" btrfs subvolume list / | grep -q '@'; then
  arch-chroot "${TARGET}" snapper -c albanix create \
    --description "baseline post-install" \
    --cleanup-algorithm number 2>/dev/null || \
    log "WARNING: baseline snapshot failed (snapper not ready yet)."
else
  log "WARNING: Btrfs @ subvolume not found; skipping baseline snapshot."
fi

# ---------------------------------------------------------------------
# 6. Remove installer leftovers from target
# ---------------------------------------------------------------------
log "Removing live/installer leftovers"
arch-chroot "${TARGET}" pacman -Rns --noconfirm calamares calamares-python 2>/dev/null || true
rm -f "${TARGET}/etc/albanix-live" 2>/dev/null || true
rm -f "${TARGET}/root/.bashrc" 2>/dev/null || true

# ---------------------------------------------------------------------
# 7. Regenerate initramfs (LUKS2 hooks, theme, etc.)
# ---------------------------------------------------------------------
log "Regenerating initramfs"
arch-chroot "${TARGET}" mkinitcpio -P

log "albanix-postinstall complete. Theme: ${THEME}"