#!/usr/bin/env bash
set -Eeuo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
. "$DIR/lib.sh"

main() {
  # Preserve original args for potential rerun
  ORIGINAL_ARGS=("$@")
  require_root
  detect_pkg_mgr
  install_pkgs
  if ! devs=$(wait_for_device); then
    err "No FIDO2 device detected within timeout. Plug your key and re-run."; exit 1
  fi
  log "Detected device(s): $(echo "$devs" | xargs)"

  setup_pam_u2f
  configure_login_pam
  if ! post_check; then
    offer_rerun
  fi
  log "Registered this key with your computer. Test: sudo -k; sudo true, then lock screen and touch key."
}

main "$@"
