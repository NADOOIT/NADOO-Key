#!/usr/bin/env bash
set -Eeuo pipefail

# NADOO-Key — FIDO2 Reset (GUI)
# A simple desktop helper to reset the FIDO2 application of a key.
#
# Requirements:
#  - Linux with zenity, sudo, ykman (YubiKey Manager)
#  - User needs sudo rights to access USB rules where needed
#
# WARNING: Resetting FIDO2 ERASES all FIDO/WebAuthn credentials on the key.

require() { command -v "$1" >/dev/null 2>&1 || { zenity --error --text "Fehlendes Programm: $1"; exit 1; }; }

# Try to escalate privileges up-front to avoid partial failures
need_root() {
  if [[ $EUID -ne 0 ]]; then
    # Ask via GUI for password and feed sudo
    if command -v zenity >/dev/null 2>&1; then
      PASS=$(zenity --password --title "Administrator-Rechte erforderlich" --text "Bitte Admin-Passwort eingeben (sudo)") || exit 1
      if ! echo "$PASS" | sudo -S -v >/dev/null 2>&1; then
        zenity --error --text "Falsches Passwort oder keine sudo-Rechte."; exit 1
      fi
      unset PASS
    else
      sudo -v || { echo "sudo erforderlich" >&2; exit 1; }
    fi
  fi
}

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

has_ykman() { command -v ykman >/dev/null 2>&1; }

reset_fido2() {
  if ! has_ykman; then
    zenity --error --text "YubiKey Manager (ykman) nicht gefunden. Bitte installieren: sudo apt install yubikey-manager" || true
    return 1
  fi
  zenity --warning --width=420 --text "Achtung: Das Zurücksetzen löscht alle FIDO/WebAuthn-Zugänge auf dem Schlüssel.\n\nSie benötigen den physischen Schlüssel und müssen ggf. mehrfach bestätigen.\n\nFortfahren?" || return 1
  if ! ykman fido reset; then
    zenity --error --text "Zurücksetzen fehlgeschlagen. Bitte Schlüssel erneut einstecken und erneut versuchen." || true
    return 1
  fi
  zenity --info --text "Schlüssel ggf. neu einstecken. Warte auf Gerät ..." || true
  wait_for_device || true
  return 0
}

set_pin_0000() {
  if ! has_ykman; then return 0; fi
  # Try to set PIN to 0000 if not set
  if ykman fido access change-pin -n 0000 >/dev/null 2>&1; then
    zenity --info --text "PIN wurde auf 0000 gesetzt." || true
    return 0
  fi
  # Try interactive set-pin
  if ykman fido access -h 2>/dev/null | grep -q 'set-pin'; then
    if ykman fido access set-pin <<< $'0000\n0000\n'; then
      zenity --info --text "PIN wurde auf 0000 gesetzt." || true
      return 0
    fi
  fi
  return 0
}

main() {
  require zenity
  require ykman
  # no sudo required

  zenity --info --width=480 --title "NADOO‑Key – FIDO2 Zurücksetzen" --text "Dieses Tool setzt die FIDO2‑Funktion des Sicherheitsschlüssels zurück.\n\nHinweise:\n• Alle FIDO/WebAuthn‑Anmeldungen werden gelöscht.\n• Danach kann der Schlüssel erneut provisioniert werden (PIN=0000, Fingerabdruck optional).\n\nStecken Sie den Schlüssel jetzt ein und klicken Sie auf OK." || exit 1

  if ! wait_for_device; then
    zenity --error --text "Kein FIDO2‑Gerät erkannt. Bitte Schlüssel einstecken und erneut versuchen."; exit 1
  fi

  if ! reset_fido2; then
    exit 1
  fi

  if zenity --question --text "Möchten Sie die PIN jetzt auf 0000 setzen?"; then
    set_pin_0000 || true
  fi

  zenity --info --text "Fertig. Sie können den Schlüssel jetzt erneut mit NADOO‑Key provisionieren." || true
}

main "$@"
