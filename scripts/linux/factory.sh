#!/usr/bin/env bash
set -Eeuo pipefail

# Batch/factory provisioning for many keys
# - Resets (optional), sets PIN=0000 (optional), optional fingerprint enrollment
# - Optional hook to register each key with an external IT service (e.g., WebAuthn)
# - Produces a CSV log for traceability

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$DIR/../.." && pwd)"
# shellcheck source=lib.sh
. "$DIR/lib.sh"

usage() {
  cat <<EOF
Usage: nadoo-key factory [options]

Environment variables:
  FACTORY_COUNT=N        Process N keys then exit (default: infinite until Ctrl+C)
  FACTORY_RESET=1        Reset FIDO2 app before provisioning (default: 0)
  FINGERPRINTS=N         Auto-enroll N fingerprints on Bio keys (default: 0)
  REQUIRE_UV_LOGIN=0/1   If 1, require fingerprint/PIN on login pam_u2f (default: 0)
  REQUIRE_UV_SUDO=0/1    If 1, require fingerprint/PIN for sudo pam_u2f (default: 0)
  SERVICE_HOOK=PATH      Executable called per key for external registration
                         Default: 
                           \"$ROOT_DIR/scripts/integrations/service_register.sh\" if present
  OUTPUT_CSV=PATH        Factory log CSV (default: $ROOT_DIR/factory/factory_log.csv)

Behavior:
  - Waits for device, performs actions, logs outcome, optional external hook, repeats.
  - Safe defaults: no reset, no fingerprint enrollment, UV discouraged in PAM.
EOF
}

main() {
  require_root
  detect_pkg_mgr
  install_pkgs

  mkdir -p "$ROOT_DIR/factory"
  local csv="${OUTPUT_CSV:-$ROOT_DIR/factory/factory_log.csv}"
  if [[ ! -f "$csv" ]]; then
    echo "timestamp,index,serial,model,pin_set,fingerprints,enrolled,reset,hook_status,notes" >"$csv"
  fi

  local count="${FACTORY_COUNT:-}"
  local idx=0
  local service_hook="${SERVICE_HOOK:-}";
  if [[ -z "$service_hook" && -x "$ROOT_DIR/scripts/integrations/service_register.sh" ]]; then
    service_hook="$ROOT_DIR/scripts/integrations/service_register.sh"
  fi

  log "Factory mode started. Press Ctrl+C to stop."
  while :; do
    if [[ -n "$count" && "$idx" -ge "$count" ]]; then
      log "Processed $idx keys; exiting."; break
    fi
    idx=$((idx+1))
    echo
    log "Key #$idx: Insert a FIDO2 key now."
    if ! devs=$(wait_for_device); then
      err "No FIDO2 device detected within timeout. Aborting."; exit 1
    fi
    log "Detected device(s): $(echo "$devs" | xargs)"

    local did_reset=0 pin_status="unknown" fp_enrolled=0 model="" serial=""

    # Optional reset
    if [[ "${FACTORY_RESET:-0}" == "1" ]]; then
      reset_fido2_app || warn "Reset failed or skipped."
      did_reset=1
      # Some devices need replug; wait again quietly
      wait_for_device || true
    fi

    # Set PIN=0000 if not set
    if init_new_key_pin; then
      if has_pin_set; then pin_status="true"; else pin_status="false"; fi
    fi

    # Optional fingerprint enrollment
    if [[ "${FINGERPRINTS:-0}" =~ ^[0-9]+$ && "${FINGERPRINTS:-0}" -gt 0 ]]; then
      if enroll_fingerprint_if_bio; then fp_enrolled="${FINGERPRINTS}"; fi
    fi

    # Collect info for log
    if command -v ykman >/dev/null 2>&1; then
      # ykman info formats differ; try best-effort parsing
      serial=$(ykman info 2>/dev/null | awk -F: '/Serial number/ {gsub(/ /,"",$2); print $2; exit}') || true
      model=$(ykman info 2>/dev/null | awk -F: '/Device type|Model/ {sub(/^ +/,"",$2); print $2; exit}') || true
    fi

    # External service registration hook
    local hook_status="skipped"
    if [[ -n "$service_hook" && -x "$service_hook" ]]; then
      if "$service_hook" --index "$idx" --serial "${serial}" --model "${model}"; then
        hook_status="ok"
      else
        hook_status="error"
        warn "Service hook returned non-zero for key #$idx"
      fi
    fi

    # Append to CSV
    local ts
    ts=$(date -Is)
    echo "$ts,$idx,${serial},${model},${pin_status},${FINGERPRINTS:-0},${fp_enrolled},${did_reset},${hook_status}," >>"$csv"

    log "Key #$idx done. Remove the key before proceeding to the next."
    # Wait for removal (best-effort)
    local t=10
    while ((t--)); do
      if command -v fido2-token >/dev/null 2>&1; then
        if ! fido2-token -L 2>/dev/null | grep -q '^/dev/hidraw'; then
          break
        fi
      fi
      sleep 1
    done
  done
}

case "${1:-}" in
  -h|--help|help) usage ;;
  *) main "$@" ;;
esac
