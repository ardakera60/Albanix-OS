# How to announce Albanix OS online

OS project only — no website or landing page needed. Announce via GitHub Release + community posts.

## Checklist
- [ ] GitHub Release created with ISO, .sha256, .sig attached
- [ ] Release notes written (RELEASE-NOTES.md)
- [ ] README.md + README.sq.md updated
- [ ] Changelog updated (CHANGELOG.md)
- [ ] Posted to Reddit r/linux and r/archlinux
- [ ] Submitted to DistroWatch
- [ ] Shared with Albanian tech communities

## Reddit r/linux post draft (English)

Title: Albanix OS — an Albanian-first, fast Arch-based distro with KDE Plasma 6

Body:
```
Albanix OS is a new Arch Linux–based distribution with KDE Plasma 6 (Wayland default),
built for students, developers, gamers and creators.

- Two languages only: Albanian (sq_AL.UTF-8, default) and English
- Two complete themes chosen at boot/install: Albanix Red (black/red, Albanian flag)
  and Albanix Blue (navy/gold, Kosovo flag)
- CachyOS-inspired performance: BORE kernel option, CPU-tier repos, zram+zstd,
  Btrfs + Snapper snapshots, sysctl tuning
- Secure by default: ufw, optional LUKS2, AppArmor, no telemetry, no ads
- Calamares graphical installer, offline-capable

Build from source: ./build.sh
GitHub: https://github.com/arda/albanix-os
```

## Reddit r/archlinux post draft (English)

Title: [Adoption] Albanix OS — Arch + KDE Plasma 6, Albanian-first, CachyOS-inspired perf

Body:
```
A new Arch-based distro using Calamares, KDE Plasma 6, and CachyOS-inspired performance
tuning. Full repo (PKGBUILDs, archiso profile, themes, docs) on GitHub. No telemetry.

https://github.com/arda/albanix-os
```

## DistroWatch submission

Submit at https://distrowatch.com/submit.php with:
- Name: Albanix OS
- Based on: Arch Linux
- Desktop: KDE Plasma 6
- Installer: Calamares
- Languages: Albanian, English
- Repository: https://github.com/arda/albanix-os

## Albanian tech communities (draft in Albanian / Shqip)

Titulli: Albanix OS — distrim Linux i parë shqip, i shpejtë me KDE Plasma 6

Teksti:
```
Albanix OS është një distribucion i bazuar në Arch Linux me KDE Plasma 6, i parë
shqip. Të dy gjuhët: shqip (parazgjedhje) dhe anglisht. Dy tema të plotë: Albanix Red
(e kuqe/ezë) dhe Albanix Blue (navy/art, motivi i Kosovës). Instalues grafik Calamares,
pa telemetri, pa reklama.

GitHub: https://github.com/arda/albanix-os
```

## Posting guidelines
- Do not create a website/landing page — link to the GitHub repo and README.
- Keep posts in English and Albanian where the community allows.
- Include the ISO SHA256 and GPG signature instructions.
