# Calamares installer — Albanix OS

## Module sequence (effective order)

welcome → locale → keyboard → partition → users → summary →
albanix-theme-choice → albanix-optional-groups → displaymanager →
networkcfg → hwclock → machineid → localecfg → initcpiocfg → initcpio →
luksbootkeyfile → mount → unpackfs → packages → services-systemd →
grubcfg → bootloader → shellprocess → umount → finished

shellprocess runs albanix-postinstall.sh inside the target chroot.

## Custom modules

### albanix-theme-choice
QML UI with live preview images for Albanix Red / Blue. Stores the choice to
/var/lib/calamares/albanix-theme (red|blue, default red). shellprocess applies
it to the target via `albanix-theme`.

### albanix-optional-groups
Checkboxes for Developer / Gaming / Creator / Office / Privacy. Stores selected
group IDs to /var/lib/calamares/albanix-groups; shellprocess installs them with
`albanix install-group`.

## Post-install (shellprocess)

albanix-postinstall.sh:
1. Sets timezone Europe/Tirane + NTP
2. Enables NetworkManager, bluetooth, cups, sddm, fstrim.timer, systemd-oomd,
   power-profiles-daemon, ananicy-cpp, thermald, reflector.timer,
   snapper timers, ufw (deny incoming / allow outgoing)
3. Runs albanix-repo-select (CPU-tier optimized repo, opt-in trust)
4. Applies chosen theme via albanix-theme
5. Creates baseline Btrfs snapshot via snapper
6. Removes calamares + live leftovers
7. mkinitcpio -P

## Languages

Restricted to sq and en; default sq_AL. Keyboard: al + us, Alt+Shift switcher.

## Btrfs layout

@ /, @home /home, @log /var/log, @cache /var/cache, @snapshots /.snapshots
Mount options: noatime,compress=zstd:1,space_cache=v2,discard=async

Optional LUKS2 full-disk encryption; swapfile or zram; ext4/XFS alternatives.
