# Optional package groups — Albanix OS

Selectable in the Calamares installer (albanix-optional-groups module) or later
with `albanix install-group <group>`.

| Group | Packages |
|-------|----------|
| Developer | git, nodejs, pnpm, python, rustup, docker, podman, code (VS Code OSS) |
| Gaming | steam, proton-ge, gamemode, mangohud, lutris |
| Creator | obs-studio, kdenlive, krita, gimp, inkscape, blender |
| Office | libreoffice, okular |
| Privacy | wireguard-tools, torbrowser-launcher |

Example:
```
# INSTALLED SYSTEM
albanix install-group gaming
albanix install-group developer
```