# Albanian keyboard guide — Albanix OS

## Layouts

- `al` — Albanian (Shqip) layout: ë/Ë and ç/Ç are on dedicated keys.
- `us` — English (US) layout.

## Switching

- Alt+Shift: switch between `al` and `us` (live ISO and installed system).
- Configure in System Settings → Input Device → Keyboard → Layouts.

## Typing ë/Ë and ç/Ç on a US keyboard

Enable the AltGr/compose option in KDE keyboard settings, then:

| Character | AltGr + key | Compose sequence |
|-----------|-------------|------------------|
| ë         | AltGr + e   | Compose + e + "  |
| Ë         | AltGr + E   | Compose + E + "  |
| ç         | AltGr + c   | Compose + c + ,  |
| Ç         | AltGr + C   | Compose + C + ,  |

## Console (TTY)

`/etc/vconsole.conf` sets `KEYMAP=al` so the Albanian layout works in TTYs
and during early boot.

## SDDM and Calamares

- SDDM reads /etc/sddm.conf.d/albanix.conf for the layout.
- Calamares keyboard page offers `al` and `us`; default follows the chosen
  language (sq → al, en → us).
