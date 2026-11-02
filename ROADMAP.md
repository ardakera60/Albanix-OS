# Roadmap — Albanix OS

## v0.1 — Bootable ISO + installer (this release)

- archiso live ISO, UEFI + BIOS, systemd-boot + syslinux menus.
- Calamares graphical installer, offline-capable base install.
- Albanian (sq_AL.UTF-8) + English only.
- KDE Plasma 6 Wayland default, SDDM.
- Two themes at boot: Red (default) and Blue via `albanix.theme=` kernel parameter.

## v0.5 — Both themes + welcome app complete

- Albanix Red & Blue: Plasma look-and-feel, color schemes, SDDM, Plymouth,
  bootloader, wallpaper, Konsole, fastfetch, starship.
- Welcome app "Mirë se vini në Albanix OS" (Python + Qt/QML).
- Translation workflow: .pot/.po, CI completeness check.

## v1.0 — Stable with own repository

- [albanix] pacman repo on GitHub Releases, GPG signed, albanix-keyring.
- CPU-tier optimized repo auto-selection (fast path via CachyOS or self-built).
- albanix-bench with Markdown output.
- QEMU/KVM + VirtualBox automated smoke tests in CI.

## v2.0 — More tooling

- albanix CLI (update, theme, lang, snapshot, bench, info).
- Optional installer groups: Developer, Gaming, Creator, Office, Privacy.
- AppArmor profiles, VM guest-tools auto-detection, HiDPI/multi-monitor polish.
