#!/usr/bin/env bash
set -Eeuo pipefail

# Install/Uninstall the NADOO‑Key FIDO2 Reset desktop app (Linux)
# Usage:
#   tools/reset/install_reset_desktop.sh install
#   tools/reset/install_reset_desktop.sh uninstall
#
# Installs to:
#  - /usr/local/bin/nadoo-reset-key
#  - /usr/share/applications/nadoo-reset-key.desktop

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$DIR/../.." && pwd)"
APP_BIN="/usr/local/bin/nadoo-reset-key"
DESKTOP_FILE="/usr/share/applications/nadoo-reset-key.desktop"
RECOVER_BIN="/usr/local/bin/nadoo-recover-key"
RECOVER_DESKTOP="/usr/share/applications/nadoo-recover-key.desktop"

require_root() {
  if [[ $EUID -ne 0 ]]; then
    echo "[+] Elevating with sudo ..."; exec sudo -E "$0" "$@"
  fi
}

install_prereqs() {
  # Best-effort installation of deps on common distros
  if command -v apt-get >/dev/null 2>&1; then
    apt-get update -y
    apt-get install -y zenity yubikey-manager fido2-tools expect
  elif command -v dnf >/dev/null 2>&1; then
    dnf install -y zenity yubikey-manager fido2-tools expect
  elif command -v pacman >/dev/null 2>&1; then
    pacman -Sy --noconfirm --needed zenity yubikey-manager fido2-tools expect
  else
    echo "[!] Unknown package manager. Please ensure zenity, yubikey-manager, fido2-tools are installed."
  fi
}

install_app() {
  install -m 0755 "$DIR/reset_key_gui.sh" "$APP_BIN"
  cat >"$DESKTOP_FILE" <<'EOF'
[Desktop Entry]
Type=Application
Name=NADOO‑Key: FIDO2 zurücksetzen
Comment=Sicherheitsschlüssel (FIDO2/WebAuthn) zurücksetzen
Exec=/usr/local/bin/nadoo-reset-key
Icon=security-high
Terminal=false
Categories=Utility;Security;
EOF
  # Install non-destructive recover helper
  if [[ -f "$DIR/recover_key_gui.sh" ]]; then
    install -m 0755 "$DIR/recover_key_gui.sh" "$RECOVER_BIN"
    cat >"$RECOVER_DESKTOP" <<'EOF'
[Desktop Entry]
Type=Application
Name=NADOO‑Key: FIDO2 wiederherstellen (ohne Datenverlust)
Comment=Biometrische Sperre/rotes Blinken aufheben, ohne Anmeldedaten zu löschen
Exec=/usr/local/bin/nadoo-recover-key
Icon=security-high
Terminal=false
Categories=Utility;Security;
EOF
  fi
  update-desktop-database >/dev/null 2>&1 || true
  echo "[✓] Installed desktop apps. Find them in your applications menu: 'NADOO‑Key: FIDO2 zurücksetzen' and 'NADOO‑Key: FIDO2 wiederherstellen'"
}

uninstall_app() {
  rm -f "$APP_BIN" "$DESKTOP_FILE" "$RECOVER_BIN" "$RECOVER_DESKTOP"
  update-desktop-database >/dev/null 2>&1 || true
  echo "[✓] Uninstalled."
}

main() {
  case "${1:-}" in
    install)
      require_root "$@"
      install_prereqs
      install_app
      ;;
    uninstall)
      require_root "$@"
      uninstall_app
      ;;
    *)
      echo "Usage: $0 {install|uninstall}" >&2; exit 1
      ;;
  esac
}

main "$@"
