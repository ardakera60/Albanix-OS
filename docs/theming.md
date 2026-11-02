# Theming guide — Albanix OS

Two complete system themes: Albanix Red (default) and Albanix Blue.

## Theme assets

| Theme | Palette | Motif |
|-------|---------|-------|
| Albanix Red | #E41E20 / #0B0B0F / gold #D4A537 | Albanian flag (red field, black double-headed eagle) |
| Albanix Blue | #244AA5 / #07101F / gold #D0A650 | Kosovo flag (blue field, gold map, six white stars) |

## Where the theme is chosen

1. **ISO boot menu** — entries "Albanix OS (Red)" / "Albanix OS (Blue)" pass
   `albanix.theme=red|blue` on the kernel cmdline; the live session looks right.
2. **Calamares** — custom step "Zgjidh temën / Choose your theme" with live preview
   images; choice stored to /var/lib/calamares/albanix-theme.
3. **After install** — `albanix-theme red|blue` CLI or the settings tool.

Default: Albanix Red.

## Package layout

- `albanix-theme-red` — Plasma look-and-feel org.albanix.red, color schemes
  (AlbanixRed-dark/light), SDDM theme albanix-red, Plymouth theme albanix-red.
- `albanix-theme-blue` — Plasma look-and-feel org.albanix.blue, color schemes
  (AlbanixBlue-dark/light), SDDM theme albanix-blue, Plymouth theme albanix-blue.
- `albanix-theme-switcher` — `albanix-theme` CLI + desktop file.
- `albanix-wallpapers` — /usr/share/wallpapers/Albanix-Red/ and /usr/share/wallpapers/Albanix-Blue/
  with contents/images at 3840x2160, 2560x1600, 1920x1080, 1366x768, 3440x1440 + metadata.json.
  SVG fallbacks ship so the build never fails; final wallpapers come from a
  separate wallpaper prompt.

## Applying a theme (idempotent, with rollback)

`albanix-theme <red|blue>` runs these steps atomically:
1. lookandfeeltool apply org.albanix.<theme>
2. plasma-apply-colorscheme
3. plasma-apply-wallpaperimage (desktop + lock screen)
4. SDDM conf.d (kwriteconfig6 / /etc/sddm.conf.d/albanix.conf)
5. plymouth-set-default-theme + mkinitcpio -P
6. bootloader theme (grub-mkconfig / systemd-boot)
7. Konsole profile, GTK settings, fastfetch, starship

If any step fails, the previous theme is restored (rollback). Safe to re-run.

## Colors per theme (dark default; light variant available)

### Albanix Red
- Window: #0B0B0F / View: #15151B / Button: #2A2A33 / Selection: #E41E20
- Header: #15151B / Tooltip: #2A2A33 / Link: #D4A537 / Disabled: #5A5A62

### Albanix Blue
- Window: #07101F / View: #0E1A33 / Button: #1A2845 / Selection: #244AA5
- Header: #0E1A33 / Tooltip: #1A2845 / Link: #D0A650 / Disabled: #5A6A8A

## Original SVG assets

All drawn for Albanix OS (no third-party tracing):
- themes/assets/logo-albanix.svg — shield with stylized A + eagle mark
- themes/assets/wordmark-albanix.svg — ALBANIX OS wordmark
- themes/assets/eagle-mark.svg — minimal geometric double-headed eagle

## Verification checklist (per theme)

- [ ] Plasma look-and-feel applies (lookandfeeltool)
- [ ] Color scheme dark + light switches
- [ ] SDDM login screen shows correct colors + background
- [ ] Plymouth boot splash shows correct colors
- [ ] Wallpaper appears on desktop + lock screen instantly
- [ ] Konsole color scheme matches
- [ ] fastfetch logo + colors match theme
- [ ] starship prompt matches theme
- [ ] Bootloader menu styled
