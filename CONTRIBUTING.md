# Contributing to Albanix OS

Albanix OS is an OS project only — no website, landing page or web app. All
documentation lives in this README and /docs as Markdown.

## How to contribute

1. Fork the repo, create a branch from `main`.
2. Make your change (script, PKGBUILD, theme asset, doc).
3. Run the checks locally: `shellcheck` on shell scripts, `ruff` on Python,
   `markdownlint` on Markdown.
4. Add Albanian translations for every new user-facing string (gettext .po in
   `po/sq/`). Run the translation completeness check before opening a PR.
5. Open a pull request against `main`. Link the issue it resolves.

## Code style

- Shell: POSIX-compatible where possible, `set -euo pipefail`, shellclean.
- Python: ruff-configurable, Qt for the welcome app.
- Markdown: one sentence per line is encouraged but not required.
- SVG assets: original drawings, no traced third-party logos.

## Translations

All user-facing strings in Calamares branding, the welcome app and custom
tools must be translated into Albanian (sq) and kept in sync with English (en).
See the translation check workflow in `.github/workflows/translations.yml`.

## Testing

Test ISO builds in QEMU/KVM (OVMF for UEFI) and VirtualBox. See docs/troubleshooting.md
for the 25 most common failures and the smoke-test script in scripts/.

## Licensing

Code: GPL-3.0-or-later. Original Albanix assets: same license unless noted.
Do not copy CachyOS branding; performance ideas are credited in README.md.
