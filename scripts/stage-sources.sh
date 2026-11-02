#!/bin/bash
# stage-sources.sh — copy every PKGBUILD's source files into its package dir.
# Runs on the HOST (or inside a build container) before makepkg.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
P="$ROOT/packages"
A="$ROOT/archiso/profiles/albanix/airootfs/etc"
T="$ROOT/themes"
S="$ROOT/scripts"
C="$ROOT/calamares"

log() { printf '[stage-sources] %s\n' "$*" >&2; }

# ---------------------------------------------------------------- mkdirs
mkdir -p \
  "$P"/albanix-keyring \
  "$P"/albanix-branding \
  "$P"/albanix-wallpapers/Albanix-Red/contents/images \
  "$P"/albanix-wallpapers/Albanix-Blue/contents/images \
  "$P"/albanix-settings \
  "$P"/albanix-tools \
  "$P"/albanix-bench \
  "$P"/albanix-theme-red \
  "$P"/albanix-theme-blue \
  "$P"/albanix-theme-switcher \
  "$P"/albanix-welcome \
  "$P"/albanix-installer-config

# ---------------------------------------------------------------- branding
cp "$A/os-release" "$A/issue" "$A/motd"        "$P/albanix-branding/"
cp "$T/assets/logo-albanix.svg" \
   "$T/assets/wordmark-albanix.svg" \
   "$T/assets/eagle-mark.svg"                  "$P/albanix-branding/"

# ---------------------------------------------------------------- wallpapers
# stage files into $P/albanix-wallpapers/Albanix-{Red,Blue} matching the
# PKGBUILD source layout
for side in "red Red" "blue Blue"; do
  set -- $side
  src="$T/wallpapers/Albanix-$2"
  dst="$P/albanix-wallpapers/Albanix-$2"
  mkdir -p "$dst/contents/images"
  cp "$src/"*.svg "$dst/" 2>/dev/null || true
  cp "$src/metadata.json" "$dst/"
  cp -r "$src/contents/images/." "$dst/contents/images/"
done

# ---------------------------------------------------------------- settings
cp "$A/sysctl.d/99-albanix-performance.conf"              "$P/albanix-settings/99-albanix-performance.conf"
cp "$A/systemd/zram-generator.conf.d/albanix.conf"        "$P/albanix-settings/albanix.conf"
cp "$A/ananicy.d/albanix.rules"                            "$P/albanix-settings/albanix.rules"
cp "$A/power-profiles-daemon.config"                      "$P/albanix-settings/power-profiles-daemon.config"
cp "$A/thermald/thermald.conf"                            "$P/albanix-settings/thermald.conf"
cp "$A/udev/rules.d/60-albanix-iosched.rules"             "$P/albanix-settings/60-albanix-iosched.rules"
cp "$A/systemd/oomd.conf"                                 "$P/albanix-settings/oomd.conf"
cp "$A/xdg/reflector/reflector.conf"                      "$P/albanix-settings/reflector.conf"

# ---------------------------------------------------------------- tools & bench
cp "$S/albanix-repo-select"      "$P/albanix-tools/albanix-repo-select"
cp "$S/albanix-graphics-select"  "$P/albanix-tools/albanix-graphics-select"
cp "$S/albanix-bench"            "$P/albanix-bench/albanix-bench"
cp "$S/albanix-theme"            "$P/albanix-theme-switcher/albanix-theme"

# ---------------------------------------------------------------- themes
cp "$T/red/org.albanix.red.metadata.desktop"  "$P/albanix-theme-red/" 2>/dev/null || true
cp "$T/red/org.albanix.red.layout.js"         "$P/albanix-theme-red/"
cp "$T/red/"Albanix-Red-{dark,light}.colors   "$P/albanix-theme-red/"
cp -r "$T/red/sddm-albanix-red"               "$P/albanix-theme-red/"
cp -r "$T/red/plymouth-albanix-red"           "$P/albanix-theme-red/"

cp "$T/blue/org.albanix.blue.metadata.desktop" "$P/albanix-theme-blue/" 2>/dev/null || true
cp "$T/blue/org.albanix.blue.layout.js"        "$P/albanix-theme-blue/"
cp "$T/blue/"Albanix-Blue-{dark,light}.colors  "$P/albanix-theme-blue/"
cp -r "$T/blue/sddm-albanix-blue"              "$P/albanix-theme-blue/"
cp -r "$T/blue/plymouth-albanix-blue"          "$P/albanix-theme-blue/"

# ---------------------------------------------------------------- installer config
cp "$C/settings.conf"                            "$P/albanix-installer-config/"
cp "$C/branding/albanix/branding.desc"           "$P/albanix-installer-config/"
cp "$C/branding/albanix/show.qml"                "$P/albanix-installer-config/"
cp "$C/branding/albanix/stylesheet.qss"          "$P/albanix-installer-config/"
cp "$C/modules/"*.conf                            "$P/albanix-installer-config/" 2>/dev/null || true
cp "$C/modules/"*.py                              "$P/albanix-installer-config/" 2>/dev/null || true
cp "$C/modules/"*.qml                             "$P/albanix-installer-config/" 2>/dev/null || true
cp "$S/albanix-postinstall.sh"                   "$P/albanix-installer-config/"
cp "$C/branding/albanix/theme-preview-red.svg"   "$P/albanix-installer-config/" 2>/dev/null || true
cp "$C/branding/albanix/theme-preview-blue.svg"  "$P/albanix-installer-config/" 2>/dev/null || true

# ---------------------------------------------------------------- keyring (CI-safe placeholder)
# CI path has no project key yet; package ships structural files so the
# "Required" [albanix] SigLevel never blocks — the [albanix] repo in the ISO
# uses SigLevel = Never (documented CI/dev mode; swap to Required when the
# project GPG key exists and ci is re-run with ALBANIX_GPG_KEY set).
printf '' > "$P/albanix-keyring/albanix.gpg"
printf '# albanix-trusted: populated when the project signing key exists\n' > "$P/albanix-keyring/albanix-trusted"
cat > "$P/albanix-keyring/albanix-keyring.install" <<'EOF'
post_install() {
  echo "albanix-keyring: placeholder (no repo key published yet)."
  echo "See docs/repo-hosting.md for GPG signing ceremony."
}
EOF

log "all sources staged"
