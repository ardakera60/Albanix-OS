---
name: Translation
about: Improve Albanian (sq) or English translations
title: "[TRANSLATION] "
labels: ["translation", "good first issue"]
assignees: ""
---

## Which file needs translation?
(e.g. po/sq/albanix-welcome.po, README.sq.md, calamares branding)

## What strings are missing or need review?
Paste the English string and your suggested Albanian translation.

## Checklist
- [ ] I ran `./scripts/albanix-translate-check` locally
- [ ] My Albanian uses proper ë and ç (not machine-literal)
- [ ] I kept placeholders like `%s`, `{theme}`, `{name}` intact

---
Translations live in `po/` and are checked in CI by `.github/workflows/translations.yml`.