# [albanix] repository hosting — Albanix OS

The [albanix] pacman repo is hosted on GitHub Releases (build artifacts) and can
be mirrored on GitHub Pages. Two trust paths:

## Fast path (pre-built by Albanix project)

1. Build packages with `./build.sh` (clean chroot via makechrootpkg).
2. `repo-add albanix.db.tar.zst *.pkg.tar.zst` → `albanix.db.tar.zst`
3. GPG-sign: `gpg --detach-sign --armor albanix.db.tar.zst`
4. Attach `albanix.db.tar.zst`, `.sig`, and packages to a GitHub Release.
5. Users add to `/etc/pacman.conf`:
   ```
   [albanix]
   SigLevel = Required
   Include = /etc/pacman.d/albanix-mirrorlist
   ```
   where `albanix-mirrorlist` points at the GitHub Release asset URLs (or a
   GitHub Pages mirror).
6. Install `albanix-keyring` (contains the Albanix repo PGP public key).

## Self-built path (no external trust)

- Build every Albanix package locally with `makepkg` / `makechrootpkg`.
- Point `[albanix]` at a local directory mirror.
- Trust only Arch Linux + GPG-verified upstream sources.

## Signing key

- Generate: `gpg --full-gen-key` (RSA 4096, no expiration recommended for a repo key).
- Back up the private key offline; publish the public key via `albanix-keyring`.
- CI builds: store the private key in GitHub Secrets (`ALBANIX_GPG_KEY`), import
  at build time, sign repo DB + ISO.
