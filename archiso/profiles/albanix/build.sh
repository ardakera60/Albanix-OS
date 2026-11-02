#!/bin/bash
# build.sh — Build the Albanix OS live ISO.
# Runs on the HOST (Arch Linux build machine, or CI container).
# Steps:
#   1. Install build dependencies.
#   2. Stage PKGBUILD source files next to each PKGBUILD (stage-sources.sh).
#   3. Build every Albanix package with makepkg.
#   4. Create the local [albanix] repo (repo-add --nosign).
#   5. Point the profile pacman.conf placeholder at the local repo and run
#      mkarchiso to produce albanix-os.iso.
#   6. Generate sha256 checksum and detached GPG signature.
#
# Usage: sudo ./build.sh     (or plain ./build.sh inside a root container)
set -euo pipefail

PROFILE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${PROFILE_DIR}/../../.." && pwd)"
WORK_DIR="${WORK_DIR:-/tmp/albanix-build-work}"
OUT_DIR="${OUT_DIR:-${REPO_ROOT}/out}"
GPG_KEY="${ALBANIX_GPG_KEY:-}"

log() { printf '[build.sh] %s\n' "$*" >&2; }

install_build_deps() {
  log "Installing build dependencies (HOST)"
  pacman -Sy --needed --noconfirm \
    base-devel archiso git gnupg
}

stage_sources() {
  log "Staging PKGBUILD sources"
  bash "${REPO_ROOT}/scripts/stage-sources.sh"
}

am_i_root() { [[ "$(id -u)" -eq 0 ]]; }

build_albanix_packages() {
  log "Building Albanix packages with makepkg"
  local skip=(albanix-kernel)   # custom kernel build is off by default
  local built=()

  if am_i_root; then
    if ! id -u albanixbuild &>/dev/null; then
      useradd -m -s /bin/bash albanixbuild
    fi
    chown -R albanixbuild: "${REPO_ROOT}/packages"
  fi

  for pkgdir in "${REPO_ROOT}"/packages/*/; do
    local name
    name="$(basename "${pkgdir}")"
    if [[ " ${skip[*]} " == *" ${name} "* ]]; then
      log "SKIP: ${name} (disabled by default)"
      continue
    fi
    log "Building ${name} ..."
    if am_i_root; then
      su -s /bin/bash albanixbuild -c "cd '${pkgdir}' && makepkg -f --nodeps --noconfirm"
    else
      (cd "${pkgdir}" && makepkg -f --nodeps --noconfirm)
    fi
    built+=("${name}")
  done

  # Collect all built packages into $WORK_DIR/repo.
  mkdir -p "${WORK_DIR}/repo/x86_64"
  find "${REPO_ROOT}/packages" -maxdepth 2 -name '*.pkg.tar.zst' \
    -exec cp -t "${WORK_DIR}/repo/x86_64/" {} +
  local n
  n="$(find "${WORK_DIR}/repo" -maxdepth 2 -name '*.pkg.tar.zst' | wc -l)"
  log "Repo contents: ${n} packages, ${#built[*]} PKGBUILDs invoked"
}

setup_local_repo() {
  log "Setting up local [albanix] repository"
  (
    cd "${WORK_DIR}/repo/x86_64"
    repo-add --nosign albanix.db.tar.zst ./*.pkg.tar.zst
  )
  cat > "${WORK_DIR}/repo/albanix.repo" <<EOF
[albanix]
Server = file://${WORK_DIR}/repo/x86_64
EOF
}

build_iso() {
  log "Building live ISO with mkarchiso"
  mkdir -p "${OUT_DIR}"
  rm -rf "${WORK_DIR}/profile" "${WORK_DIR}/iso"
  # Copy the profile so we can rewrite the pacman.conf placeholder without
  # touching the repo working tree.
  cp -r "${PROFILE_DIR}" "${WORK_DIR}/profile"
  sed -i "s#%%ALBANIX_LOCAL_REPO%%#${WORK_DIR}/repo#" "${WORK_DIR}/profile/pacman.conf"
  mkarchiso -v -w "${WORK_DIR}/iso" -o "${OUT_DIR}" "${WORK_DIR}/profile"
}

sign_iso() {
  local iso
  iso="$(find "${OUT_DIR}" -maxdepth 1 -name '*.iso' | head -n1 || true)"
  if [[ -z "${iso}" ]]; then
    log "ERROR: no ISO found in ${OUT_DIR}"
    exit 1
  fi
  log "Generating checksums and signature for ${iso}"
  sha256sum "${iso}" > "${iso}.sha256"
  if [[ -n "${GPG_KEY}" ]]; then
    gpg --detach-sign --armor --default-key "${GPG_KEY}" "${iso}"
  else
    log "ALBANIX_GPG_KEY not set; skipping ISO signature"
  fi
  log "ISO ready: ${iso}"
}

main() {
  install_build_deps
  stage_sources
  build_albanix_packages
  setup_local_repo
  build_iso
  sign_iso
  log "BUILD COMPLETE. Output in ${OUT_DIR}"
}

main "$@"
