# Security Policy — Albanix OS

## Supported versions

| Version | Supported |
|---------|-----------|
| 0.1 (current ISO) | Yes |

## Reporting a vulnerability

Please do not open public issues for security vulnerabilities. Email the
maintainers (via GitHub) or open a draft issue marked "SECURITY" and we will
coordinate disclosure.

## What we do

- ufw enabled by default: deny incoming, allow outgoing.
- Optional LUKS2 full-disk encryption in Calamares.
- AppArmor profiles documented; enforced where upstream ships them.
- No telemetry, no phone-home except mirrors + NTP.
- GPG-signed [albanix] repository and ISOs.

## Trust model

- Fast path: CachyOS optimized repos require trusting key F3B607488DB35A47 —
  opt-in only, generic x86-64 fallback is the default.
- Self-built path: everything in this repo is built from source PKGBUILDs.
