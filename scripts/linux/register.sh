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
  # Auto-install user-level auto-unlock agent (low-friction unlock on plug-in)
  # Disable by setting AUTO_UNLOCK=0
  if [[ "${AUTO_UNLOCK:-1}" != "0" ]]; then
    local target_user="${SUDO_USER:-$USER}"
    local root_dir
    root_dir="$(cd "$DIR/../.." && pwd)"
    if [[ -f "$root_dir/tools/auto_unlock/install.sh" ]]; then
      log "Installing auto-unlock agent for user: ${target_user} (prompts to unlock on key plug-in)"
      if sudo -u "$target_user" bash "$root_dir/tools/auto_unlock/install.sh" install; then
        log "Auto-unlock agent installed and started for ${target_user}."
      else
        warn "Auto-unlock installation skipped/failed; you can install later via: $root_dir/tools/auto_unlock/install.sh install"
      fi
    fi
  fi
  log "Registered this key with your computer. Test: sudo -k; sudo true, then lock screen and touch key."
}

main "$@"
