# Installation — Albanix OS

## Boot the ISO

Write `albanix-os.iso` to a USB stick (HOST):

```bash
sudo dd if=albanix-os.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

Boot from USB. Choose from the systemd-boot (UEFI) or syslinux (BIOS) menu:

- "Albanix OS (Red)" — default theme, Albanian.
- "Albanix OS (Blue)" — Kosovo theme, Albanian.
- "Albanix OS (safe graphics)" — nomodeset, English, for troubleshooting.
- "Albanix OS (Red) — Linux LTS kernel".

The live session starts SDDM with the `albanix` user (password: `albanix`).
Root is locked; use `sudo`.

## Install with Calamares

Open a terminal or the welcome app and run:

```bash
# IN THE LIVE ISO
calamares
```

Steps:

1. Welcome (Shqip / English — default Shqip).
2. Keyboard — Albanian (`al`) + US, Alt+Shift to switch. AltGr/compose types
   ë/Ë and ç/Ç on a US keyboard.
3. Timezone — Europe/Tirane (Albania) or Europe/Belgrade (Kosovo).
4. Partitioning — Btrfs @/@home/@log/@cache/@snapshots default; optional LUKS2
   full-disk encryption, swapfile or zram; ext4/XFS alternatives available.
5. User — create your account; sudo via wheel group (password required).
6. Theme choice — Albanix Red (default) or Blue; live preview images shown.
7. Optional groups — Developer, Gaming, Creator, Office, Privacy.
8. Summary → Install.

The installer is offline-capable: all base packages are on the ISO.

## After install

- First login launches "Mirë se vini në Albanix OS".
- Re-run anytime from the application menu.
- Use the `albanix` CLI for updates, theme/language switches, snapshots,
  benchmarks and system info (see README.md).

## Dual-boot

Albanix OS uses systemd-boot on UEFI and GRUB on BIOS. Btrfs snapshots are
bootable via grub-btrfs (BIOS) / systemd-boot + snapper (UEFI). The installer
detects existing operating systems and adds entries.
