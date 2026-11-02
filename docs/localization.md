# Albanian localization — Albanix OS

Exactly two languages: Albanian (sq_AL.UTF-8, default) and English (en_US.UTF-8).
No other locales are generated.

## 1. Locales

`/etc/locale.gen` generates only:
```
sq_AL.UTF-8 UTF-8
en_US.UTF-8 UTF-8
```

`/etc/locale.conf` sets the full Albanian convention set:
- LANG=sq_AL.UTF-8
- Dates: dd.MM.yyyy
- Clock: 24-hour
- Decimal separator: comma
- Thousands: space/dot per Albanian convention
- Currency: ALL (Lek)
- Week starts: Monday
- Paper: A4

If `sq_AL.UTF-8` is missing from glibc on your build host, generate it from CLDR
with `localedef` before running `locale-gen`.

## 2. Keyboard

- Layouts: `al` (Albanian) + `us` (English)
- Switcher: Alt+Shift
- ë/Ë and ç/Ç on a US keyboard: AltGr+e / AltGr+c (compose key)
- `/etc/vconsole.conf`: KEYMAP=al (TTY)
- KDE (X11 + Wayland): configured in System Settings → Input Device → Keyboard
- SDDM: reads /etc/sddm.conf.d/albanix.conf
- Calamares keyboard page: offers al + us; default follows chosen language

## 3. Timezone & NTP

- Default: Europe/Tirane (Albania)
- Selectable: Europe/Belgrade (Kosovo, same UTC offset + DST)
- `timedatectl set-ntp true`
- Servers: Balkan/European pool + global fallback (chrony or systemd-timesyncd)
- Hardware clock: UTC
- Calamares preselects Europe/Tirane when Albanian is chosen

## 4. Language packs & spellcheck (verify exact Arch package names)

- kde-l10n-sq — Plasma Albanian translations (upstream: l10n.kde.org stable-kf6/sq;
  coverage is partial — albanix-welcome ships its own full sq translation)
- hunspell-sq — Albanian Hunspell dictionary
- aspell-sq — Albanian Aspell dictionary
- Firefox sq language pack (firefox-i18n-sq)
- LibreOffice sq (libreoffice-still-sq or libreoffice-fresh-sq)
- Thunderbird sq (thunderbird-i18n-sq)

Note: KDE Albanian translation coverage is ~5% upstream (per l10n.kde.org). Most of
Plasma stays in English until the KDE Albanian team completes translations. Albanix
welcome app and all custom tools are 100% translated into Albanian.

## 5. Fonts

Noto, Noto Emoji, Inter, JetBrains Mono Nerd, Fira Code, Liberation, DejaVu,
Cantarell — all with full Latin Extended coverage (ë, ç, etc.).

## 6. Translation workflow

- Source strings: `po/albanix-welcome.pot`
- Albanian translations: `po/sq/albanix-welcome.po` (100% translated)
- CI check: `.github/workflows/translations.yml` runs `albanix-translate-check`
- Local check: `./scripts/albanix-translate-check`

To add a new user-facing string:
1. Wrap it in `_("...")` in the Python source.
2. Run `xgettext` to update `po/albanix-welcome.pot`.
3. Translate the new msgid in `po/sq/albanix-welcome.po`.
4. Run `scripts/albanix-translate-check` — CI will fail on empty msgstr.

## 7. Welcome app

"Mirë se vini në Albanix OS" (Python + PyQt6):
- Pages: greeting, language, keyboard, timezone, theme (Red/Blue with previews),
  optional software groups, privacy, tips, done
- Autostarts once on first login via /etc/xdg/autostart
- Reopenable from the application menu
- All strings gettext-wrapped and fully translated to Albanian
