#!/bin/bash
# Top-level build.sh — thin wrapper that calls the archiso profile build.sh.
# Runs on the HOST (Arch Linux build machine).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILE_BUILD="${SCRIPT_DIR}/archiso/profiles/albanix/build.sh"

if [[ ! -x "${PROFILE_BUILD}" ]]; then
  chmod +x "${PROFILE_BUILD}"
fi

exec "${PROFILE_BUILD}" "$@"