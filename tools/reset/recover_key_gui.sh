#!/usr/bin/env bash
set -Eeuo pipefail

# NADOO-Key — FIDO2 Recover (GUI, non-destructive)
# Unlocks a red-blinking/locked Bio key by verifying the FIDO2 PIN.
# This clears biometric lockout WITHOUT erasing any FIDO credentials.
#
# Requirements: zenity, ykman, expect, fido2-tools (for device detection)

# Normalize locale so ykman prompts are predictable
if [[ "${LC_ALL:-}" != "C" ]]; then export LC_ALL=C; fi
if [[ "${LANG:-}" != "C" ]]; then export LANG=C; fi

require() { command -v "$1" >/dev/null 2>&1 || { zenity --error --text "Fehlendes Programm: $1"; exit 1; }; }

wait_for_device() {
  local tries=60
  while ((tries--)); do
    if command -v fido2-token >/dev/null 2>&1; then
      if fido2-token -L 2>/dev/null | grep -q '^/dev/hidraw'; then
        return 0
      fi
    fi
    sleep 1
  done
  return 1
}

verify_pin() {
  local pin="$1"
  /usr/bin/expect <<EOF
set timeout 30
# Force C locale for consistent prompts
spawn env LC_ALL=C LANG=C ykman fido access verify-pin
expect {
  -re {(?i)(enter|eingeben|eingabe).*(pin).*:? *$} { send "${pin}\r"; exp_continue }
  -re {(?i)(pin).*(enter|eingeben|eingabe).*:? *$} { send "${pin}\r"; exp_continue }
  -re {(?i)pin.*:? *$} { send "${pin}\r"; exp_continue }
  timeout { }
  eof { }
}
expect eof
EOF
}

main() {
  require zenity
  require ykman
  require expect
  require fido2-token

  zenity --info --width=520 --title "NADOO‑Key – FIDO2 Wiederherstellen" --text "Dieses Tool entsperrt Ihren Sicherheitsschlüssel, ohne Daten zu löschen.\n\nWas es macht:\n• Prüft die FIDO2‑PIN (z. B. 0000)\n• Hebt damit die Fingerabdruck‑Sperre auf (rotes Blinken)\n\nStecken Sie den Schlüssel ein und klicken Sie OK." || exit 1

  if ! wait_for_device; then
    zenity --error --text "Kein FIDO2‑Gerät erkannt. Bitte einstecken und erneut versuchen."; exit 1
  fi
  # Small delay to allow device to become fully ready
  sleep 2

  PIN=$(zenity --entry --hide-text --title "FIDO2‑PIN eingeben" --text "Bitte geben Sie die FIDO2‑PIN ein (Standard: 0000)") || exit 1
  if [[ -z "$PIN" ]]; then exit 1; fi

  if verify_pin "$PIN"; then
    zenity --info --text "Erfolgreich. Biometrische Sperre wurde aufgehoben.\n\nHinweis: Falls sudo/Login Fingerabdruck zwingend verlangt, können Sie temporär auf Touch‑only umstellen (REQUIRE_UV_LOGIN=0 / REQUIRE_UV_SUDO=0) und später wieder aktivieren." || true
  else
    zenity --error --text "PIN‑Prüfung fehlgeschlagen. Bitte erneut versuchen oder PIN prüfen." || true
    exit 1
  fi
}

main "$@"
