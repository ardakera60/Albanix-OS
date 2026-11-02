# Troubleshooting — Albanix OS

1. **mkarchiso fails: "profile not found"** — run build.sh from the repo root;
   the profile path is `archiso/profiles/albanix`.
2. **Calamares crashes on start** — missing module .conf in
   `/usr/lib/calamares/modules/`. Reinstall albanix-installer-config.
3. **Bootloader not installing (UEFI)** — boot the ISO in UEFI mode; ensure
   `/sys/firmware/efi` exists in the live session.
4. **NVIDIA black screen** — use "safe graphics" entry, then install
   `nvidia-open-dkms` and add `nvidia-drm.modeset=1` to kernel cmdline.
5. **Wrong keyboard layout** — live ISO uses `al`; set X11/Wayland layout in
   System Settings → Input Device → Keyboard.
6. **Timezone not applied** — Calamares writes /etc/timezone and runs
   `timedatectl set-timezone`. Re-run: `sudo timedatectl set-timezone Europe/Tirane`.
7. **Repo signature errors** — import albanix-keyring: `sudo pacman-key --init &&
   sudo pacman-key --populate albanix`.
8. **Plymouth theme not applying** — run `sudo plymouth-set-default-theme
   albanix-red && sudo mkinitcpio -P`.
9. **Theme not switching** — run `albanix-theme red` (or blue) and log out/in.
10. **zram not active** — `systemctl status systemd-zram-setup@zram0.service`.
11. **Btrfs snapshot boot problems** — reinstall grub-btrfs or run
    `sudo grub-mkconfig -o /boot/grub/grub.cfg` (BIOS) /
    `sudo bootctl update` (UEFI).
12. **Flatpak/Flathub missing** — `flatpak remote-add --if-not-exists flathub
    https://flathub.org/repo/flathub.flatpakrepo`.
11. **Wi-Fi not detected** — ensure `linux-firmware` is installed and
    `NetworkManager` is running.
12. **Bluetooth missing** — `systemctl start bluetooth && bluetoothctl power on`.
13. **No sound** — PipeWire + WirePlumber: `systemctl --user restart
    pipewire pipewire-pulse wireplumber`.
14. **ISO boots to black screen** — add `nomodeset` (safe graphics entry).
15. **SDDM does not start** — `systemctl status sddm`; check /var/log/sddm.log.
16. **Albanian ë/ç not typing** — use AltGr+e / AltGr+c (compose) or switch
    to the `al` layout.
17. **Locale shows C instead of sq** — `sudo locale-gen` and check
    /etc/locale.conf contains LANG=sq_AL.UTF-8.
18. **Slow boot** — `systemd-analyze blame`; disable unneeded services.
19. **OOM kills** — systemd-oomd is enabled; tune /etc/systemd/oomd.conf.
20. **Updates fail on [albanix] repo** — regenerate mirrorlist via albanix CLI
    or use Arch mirrors only.
21. **Calamares partition step empty** — select a target disk first.
22. **Grub-btrfs snapshots missing** — run `sudo grub-mkconfig` after installing
    snapper and grub-btrfs.
23. **Wayland vs X11** — choose Plasma (Wayland) at SDDM; X11 session listed too.
24. **Touchpad not working** — `libinput` is installed; check
    `xinput list` (X11) or KDE input settings (Wayland).
25. **Build host lacks archiso** — `sudo pacman -S archiso devtools`.
