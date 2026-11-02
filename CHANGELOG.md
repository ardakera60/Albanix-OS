# Changelog — Albanix OS

## [0.1.0] — 2026-11-02 (planned)

- Project skeleton: README (en/sq), LICENSE GPL-3.0, docs roadmap.
- Phase 1 archiso profile: profiledef.sh, packages.x86_64, pacman.conf,
  customize_airootfs.sh, airootfs overlay (os-release, locale, vconsole, SDDM),
  UEFI systemd-boot entries (Red/Blue/safe graphics), BIOS syslinux menu.
- Phase 1 Calamares: settings.conf, branding.desc, welcome/locale/keyboard/
  partition/users/summary module configs.
- PKGBUILDs: albanix-keyring, albanix-branding.

## [Unreleased]

- Phase 2: performance layer (sysctl, zram, ananicy, Btrfs/Snapper, albanix-bench).
- Phase 3: localization (welcome app, gettext tooling, Albanian fonts).
- Phase 4: Calamares post-install shellprocess, theme-choice step, optional groups.
- Phase 5: both themes (Plasma, SDDM, Plymouth, bootloader, Konsole, fastfetch, starship).
- Phase 6: own [albanix] repo, build.sh, CI, QEMU testing, troubleshooting.
- Phase 7: albanix CLI, optional package groups (Developer/Gaming/Creator/Office/Privacy).
- Phase 8: README.sq.md, CONTRIBUTING, CODE_OF_CONDUCT, SECURITY, issue templates.
