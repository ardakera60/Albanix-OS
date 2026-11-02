#!/bin/bash
# build.sh — Build the Albanix OS live ISO.
# Runs on the HOST (Arch Linux build machine).
# Steps:
#   1. Install build dependencies.
#   2. Build Albanix packages in a clean chroot (devtools/makechrootpkg).
#   3. Update the local [albanix] repository (repo-add + GPG sign).
#   4. Run mkarchiso to produce albanix-os.iso.
#   5. Generate sha256 checksum and detached GPG signature.
#
# Usage: sudo ./build.sh
set -euo pipefail

PROFILE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/profiles/albanix" && pwd)"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="${WORK_DIR:-/tmp/albanix-build-work}"
OUT_DIR="${OUT_DIR:-${REPO_DIR}/out}"
GPG_KEY="${ALBANIX_GPG_KEY:-}"

log() { printf '[build.sh] %s\n' "$*" >&2; }

require_root() {
  if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
    log "ERROR: build.sh must run as root (use sudo)." >&2
    exit 1
  fi
}

install_build_deps() {
  log "Installing build dependencies (HOST)"
  pacman -Sy --needed --noconfirm \
    archiso git gnupg squashfs-tools xorriso dosfstools \
    devtools makechrootpkg devtools repo reflector
}

build_albanix_packages() {
  log "Building Albanix packages in clean chroot (HOST)"
  local pkgs=(
    albanix-keyring
    albanix-branding
    albanix-wallpapers
    albanix-welcome
    albanix-settings
    albanix-installer-config
    albanix-theme-red
    albanix-theme-blue
    albanix-theme-switcher
    albanix-tools
    albanix-bench
  )
  local pkgdir
  for pkg in "${pkgs[@]}"; do
    pkgdir="${REPO_DIR}/packages/${pkg}"
    if [[ ! -d "${pkgdir}" ]]; then
      log "WARNING: ${pkgdir} not found, skipping."
      continue
    fi
    log "Building ${pkg} ..."
    (cd "${pkgdir}" && makechrootpkg -c -r "${WORK_DIR}/chroot")
  done
}

setup_local_repo() {
  log "Setting up local [albanix] repository (HOST)"
  mkdir -p "${WORK_DIR}/repo/x86_64"
  # Copy built packages into the repo.
  cp "${REPO_DIR}"/packages/*/*.pkg.tar.zst "${WORK_DIR}/repo/x86_64/" 2>/dev/null || true
  (cd "${WORK_DIR}/repo/x86_64" && repo-add albanix.db.tar.zst *.pkg.tar.zst)
  # Sign the repo database with the project GPG key (if available).
  if [[ -n "${GPG_KEY}" ]]; then
    gpg --detach-sign --armor --default-key "${GPG_KEY}" "${WORK_DIR}/repo/x86_64/albanix.db.tar.zst"
  else
    log "WARNING: ALBANIX_GPG_KEY not set; repo database left unsigned."
  fi
}

build_iso() {
  log "Building live ISO with mkarchiso (HOST)"
  mkdir -p "${OUT_DIR}"
  mkarchiso -v -w "${WORK_DIR}/iso" -o "${OUT_DIR}" "${PROFILE_DIR}"
}

sign_iso() {
  local iso
  iso="$(ls "${OUT_DIR}"/albanix*.iso 2>/dev/null | head -n1 || true)"
  if [[ -z "${iso}" ]]; then
    log "ERROR: no ISO found in ${OUT_DIR}"
    exit 1
  fi
  log "Generating checksums and signature for ${iso}"
  sha256sum "${iso}" > "${iso}.sha256"
  if [[ -n "${GPG_KEY}" ]]; then
    gpg --detach-sign --armor --default-key "${GPG_KEY}" "${iso}"
  fi
  log "ISO ready: ${iso}"
}

main() {
  require_root
  install_build_deps
  build_albanix_packages
  setup_local_repo
  build_iso
  sign_iso
  log "BUILD COMPLETE. Output in ${OUT_DIR}"
}

main "$@"