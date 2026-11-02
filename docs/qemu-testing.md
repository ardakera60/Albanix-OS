# QEMU/KVM + VirtualBox testing — Albanix OS

## QEMU/KVM with OVMF (UEFI)

```bash
# HOST
qemu-system-x86_64 \
  -machine q35,accel=kvm -cpu host -m 4096 -smp 2 \
  -drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2-ovmf/x64/OVMF_CODE.fd \
  -drive if=pflash,format=raw,file=/usr/share/edk2-ovmf/x64/OVMF_VARS.fd \
  -cdrom albanix-os.iso -boot order=d -vnc :1
```

## QEMU BIOS (syslinux menu)

```bash
# HOST
qemu-system-x86_64 -accel kvm -m 2048 -cdrom albanix-os.iso -boot order=d -vnc :1
```

## VirtualBox

- Create VM: Type "Linux", Version "Arch Linux (64-bit)".
- Enable EFI (for UEFI) or disable (for BIOS/syslinux).
- Attach albanix-os.iso to optical drive, boot.

## Automated smoke test

```bash
# HOST
./scripts/albanix-iso-smoke-test albanix-os.iso
```

Boots in QEMU headless, checks serial for SDDM/locale/timezone, exits PASS/FAIL.

## What to verify manually

- systemd-boot (UEFI) / syslinux (BIOS) menu shows Red / Blue / safe graphics.
- Selecting Red/Blue applies the matching live-session theme instantly.
- SDDM autologins as albanix / albanix.
- `localectl` shows sq_AL.UTF-8, keymap al.
- `timedatectl` shows Europe/Tirane, NTP yes, RTC UTC.
- `calamares` launches offline.
- `albanix-theme blue` switches the live session to Blue.

Items that cannot be fully automated / need real hardware:
- NVIDIA/AMD/Intel GPU driver selection and hybrid graphics.
- Wi-Fi/Bluetooth cards, touchpads, HiDPI/multi-monitor.
- LUKS2 full-disk encryption unlock at boot.
- VM guest tools auto-detection (QEMU/KVM, VirtualBox, VMware).
- Real Btrfs snapshot boot/rollback.
- GPG key signing ceremony for the [albanix] repo.
