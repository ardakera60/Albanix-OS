# Kernel build guide — Albanix OS

Two paths:

## Fast path (CachyOS repos — requires trust)

Trusts CachyOS signing key `F3B607488DB35A47` and mirrors.

```
# HOST or CHROOT (as root)
albanix-repo-select        # detects x86-64-v1/v3/v4, enables cachyos-v3/v4
pacman-key --recv-keys F3B607488DB35A47 --keyserver keyserver.ubuntu.com
pacman-key --lsign-key F3B607488DB35A47
pacman -Sy linux-cachyos-bore linux-lts
```

- `linux-cachyos-bore` = BORE scheduler (default)
- `linux-lts` = fallback boot entry

## Self-built path (no external trust)

Build the kernel from source using `packages/albanix-kernel/PKGBUILD` (template).

Config options that matter:
- `CONFIG_SCHED_BORE=y` — Burst-Oriented Response Enhancer scheduler
- Thin LTO / Clang — smaller, faster kernel
- `CONFIG_ZSTD=y` — zstd compression for modules/initramfs

Build:
```
# HOST
cd packages/albanix-kernel
makepkg -si
```

Then install `linux-lts` as the fallback boot entry.
