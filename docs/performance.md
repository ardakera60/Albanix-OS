# Performance layer — Albanix OS

CachyOS-inspired performance tuning applied to Albanix OS. Every tweak below
has a one-line reason. Two paths are supported:

- **Fast path**: use CachyOS optimized repos + `linux-cachyos-bore` kernel
  (requires trusting CachyOS key `F3B607488DB35A47` — opt-in).
- **Self-built path**: build Albanix packages from source; use the stock
  Arch kernel or self-built BORE kernel.

## 1. Kernel

Default: BORE-scheduler kernel (`linux-cachyos-bore` via fast path, or
self-built from `packages/albanix-kernel` if you add it). Fallback boot
entry: `linux-lts`.

Fast path (requires trust):
```
# HOST or CHROOT (as root)
sudo albanix-repo-select   # detects x86-64-v1/v3/v4, enables cachyos-v3/v4
sudo pacman-key --recv-keys F3B607488DB35A47 --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key F3B607488DB35A47
sudo pacman -Sy linux-cachyos-bore linux-lts
```

Self-built path: build the kernel PKGBUILD locally with `makepkg` and
install the resulting package; no external trust beyond Arch Linux.

Config options that matter (BORE kernel):
- `CONFIG_SCHED_BORE=y` — Burst-Oriented Response Enhancer scheduler
- `CONFIG_LTO=y` / Thin LTO — smaller, faster kernel
- `CONFIG_ZSTD=y` — zstd compression for modules/initramfs

## 2. CPU-tier optimized repos

`albanix-repo-select` runs `ld.so --help | grep x86-64-v` to detect the CPU
micro-architecture level (v1 / v2 / v3 / v4) and uncomments the matching
`[cachyos-v3]` / `[cachyos-v4]` block in `/etc/pacman.conf`. Generic x86-64
is the safe fallback.

## 3. sysctl tuning

File: `/etc/sysctl.d/99-albanix-performance.conf`

| Setting | Value | Reason |
|---------|-------|--------|
| vm.swappiness | 10 | Keep apps in RAM, swap only under pressure |
| vm.vfs_cache_pressure | 200 | Reclaim page cache sooner under memory pressure |
| vm.dirty_ratio / background | 30 / 10 | SSD-friendly writeback thresholds |
| vm.overcommit_memory | 1 | Better for games/compilers allocating sparse memory |
| kernel.watchdog | 0 | Reduce NMI watchdog latency spikes |
| kernel.sched_min_granularity_ns | 10000000 | Desktop interactivity |
| kernel.sched_wakeup_granularity_ns | 2000000 | Desktop interactivity |
| fs.inotify.max_user_watches | 524288 | IDEs / node / rust tooling |
| net.core.default_qdisc | fq | BBR pairs with fq |
| net.ipv4.tcp_congestion_control | bbr | Better WAN throughput/latency |

Apply: `sudo sysctl --system` (applies at boot automatically via systemd-sysctl).

## 4. I/O schedulers (udev)

File: `/etc/udev/rules.d/60-albanix-iosched.rules`

- NVMe → `none`
- SATA SSD (rotational=0) → `mq-deadline`
- HDD (rotational=1) → `bfq`

Applies at boot and on hotplug.

## 5. Memory: zram + zstd

File: `/etc/systemd/zram-generator.conf.d/albanix.conf`

- Compression: zstd
- Size: `min(ram, 8192)` MB

Service: `systemd-zram-setup@zram0.service` (starts at boot).
Check: `systemctl status systemd-zram-setup@zram0.service` and `zramctl`.

OOM: `systemd-oomd` is enabled with `/etc/systemd/oomd.conf`.

## 6. Process priority: ananicy-cpp

File: `/etc/ananicy.d/albanix.rules`

- Browsers (firefox, thunderbird) → nice +5, idle ionice
- Compilers (gcc, clang, rustc, cargo, make) → nice +5
- Games (steam, gamescope, mangohud) → nice -5, real-time ionice
- Media (obs, blender, kdenlive, ffmpeg) → nice -4

Service: `ananicy-cpp`.

## 7. Power & thermal

- `power-profiles-daemon` (default profile: balanced)
- `thermald` (laptops; safe on desktops)
- `fstrim.timer` (SSD TRIM weekly)

## 8. Btrfs + Snapper snapshots

Layout on `@` subvolume: `@`, `@home`, `@log`, `@cache`, `@snapshots`
Mount options: `noatime,compress=zstd:1,space_cache=v2,discard=async`

- `snapper` config at `/etc/snapper/configs/albanix`
- `snap-pac` hooks: snapshot before every pacman upgrade
  - `/etc/pacman.d/hooks/snapper-pre.hook`
  - `/etc/pacman.d/hooks/snapper-post.hook`
- Bootable snapshots:
  - BIOS: `grub-btrfs` adds snapshot entries via `grub-mkconfig`
  - UEFI: systemd-boot entries + `bootctl update` (see theming guide)

Rollback: reboot and select a snapshot from the boot menu, or
`snapper -c albanix rollback`.

## 9. Graphics

File: `scripts/albanix-graphics-select`

Auto-detects NVIDIA / AMD / Intel / hybrid:
- NVIDIA: `nvidia-drm.modeset=1` (Wayland-safe), suspend/resume services
- AMD/Intel: mesa drivers already present, no config needed
- Hybrid: PRIME offload via `__NV_PRIME_RENDER_OFFLOAD=1`

## 10. Benchmark

`albanix-bench` prints a Markdown table:

```
| Metric | Result |
|--------|--------|
| Boot time | X s |
| Idle RAM | Y MB |
| CPU test | Z s |
| Disk test | ... |
```

Run before/after tuning and paste into GitHub issues/README.

## Before / after numbers (template)

Fill these in after testing on your hardware:

| Metric | Stock Arch | Albanix OS |
|--------|------------|------------|
| Boot time | | |
| Idle RAM | | |
| CPU (zstd 200MB) | | |
| Disk read | | |
