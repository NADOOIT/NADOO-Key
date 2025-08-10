#!/usr/bin/env bash
set -Eeuo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
. "$DIR/lib.sh"

main() {
  require_root
  detect_pkg_mgr
  install_pkgs
  if ! devs=$(wait_for_device); then
    err "No FIDO2 device detected within timeout. Plug your key and re-run."; exit 1
  fi
  log "Detected device(s): $(echo "$devs" | xargs)"

  if prompt_yes_no "Reset FIDO2 application on the key now? This ERASES credentials. [y/N]"; then
    reset_fido2_app || exit 1
    log "Reset done. You can now run: sudo ./bin/nadoo-key provision"
  else
    log "Canceled."
  fi
}

main "$@"
