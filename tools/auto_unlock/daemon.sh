#!/usr/bin/env bash
set -Eeuo pipefail

# NADOO-Key — Auto-Unlock Agent (user session)
# Watches for newly plugged FIDO2 devices and offers to clear biometric lockout
# by verifying the FIDO2 PIN (non-destructive). Low-friction flow, no app launch.

if [[ "${LC_ALL:-}" != "C" ]]; then export LC_ALL=C; fi
if [[ "${LANG:-}" != "C" ]]; then export LANG=C; fi

require() { command -v "$1" >/dev/null 2>&1 || { echo "[!] Missing: $1"; exit 1; }; }

require zenity
require ykman
require fido2-token

LOCKDIR="${XDG_CACHE_HOME:-$HOME/.cache}/nadoo-key"
mkdir -p "$LOCKDIR"
exec 9>"$LOCKDIR/auto-unlock.lock"
flock -n 9 || { echo "[!] Already running"; exit 0; }

last_list=""

list_fido_devs() {
  fido2-token -L 2>/dev/null | awk '/^\/dev\/hidraw/ {print $1}' | sort -u || true
}

prompt_unlock() {
  local pin
  zenity --question --width=420 --title "FIDO2-Schlüssel erkannt" \
    --text "Es wurde ein FIDO2-Schlüssel erkannt.\n\nMöchten Sie die biometrische Sperre (rotes Blinken) aufheben?\nDies prüft nur die FIDO2-PIN und löscht KEINE Anmeldedaten." \
    --ok-label "Jetzt entsperren" --cancel-label "Später" || return 1
  pin=$(zenity --entry --hide-text --title "FIDO2‑PIN" --text "Bitte PIN eingeben (Standard: 0000)") || return 1
  [[ -z "$pin" ]] && return 1
  if env LC_ALL=C LANG=C ykman fido access verify-pin <<<"$pin" >/dev/null 2>&1; then
    zenity --info --timeout=3 --text "Schlüssel entsperrt." >/dev/null 2>&1 || true
    return 0
  else
    zenity --error --timeout=5 --text "PIN-Prüfung fehlgeschlagen." >/dev/null 2>&1 || true
    return 1
  fi
}

main() {
  while true; do
    local now new
    now=$(list_fido_devs)
    # If a new device appeared (now contains something not in last_list)
    if [[ -n "$now" && "$now" != "$last_list" ]]; then
      # Detect newly added paths
      new=$(comm -13 <(printf '%s\n' "$last_list" | sort) <(printf '%s\n' "$now" | sort) || true)
      if [[ -n "$new" ]]; then
        sleep 2
        prompt_unlock || true
      fi
      last_list="$now"
    fi
    sleep 3
  done
}

main "$@"
