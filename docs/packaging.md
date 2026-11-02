# Packaging guide — Albanix OS

All Albanix packages live in `packages/` and are built with `makepkg` / `makechrootpkg`
in a clean chroot (devtools). The full list:

- albanix-keyring — [albanix] repo PGP keyring
- albanix-branding — os-release, issue, motd, logo SVGs
- albanix-wallpapers — SVG fallback wallpapers (Red + Blue)
- albanix-welcome — welcome app (Python + PyQt6)
- albanix-settings — sysctl, zram, ananicy, udev, oomd, reflector, ufw
- albanix-installer-config — Calamares modules + post-install script
- albanix-theme-red / albanix-theme-blue — Plasma, SDDM, Plymouth themes
- albanix-theme-switcher — albanix-theme CLI
- albanix-tools — albanix-repo-select, albanix-graphics-select, albanix CLI
- albanix-bench — performance benchmark
- albanix-kernel — optional self-built BORE kernel template

Build order (dependencies):
1. albanix-keyring
2. albanix-branding
3. albanix-wallpapers
4. albanix-settings
5. albanix-tools
6. albanix-bench
7. albanix-theme-red, albanix-theme-blue, albanix-theme-switcher
8. albanix-welcome
9. albanix-installer-config

Then `repo-add` into the local `[albanix]` repo and run `mkarchiso`.

## Signing
- Generate a repo GPG key; back up the private key offline.
- Publish the public key via albanix-keyring.
- CI signs repo DB + ISO with ALBANIX_GPG_KEY from GitHub Secrets.
