#!/usr/bin/env bash
set -Eeuo pipefail

# Install/uninstall NADOO-Key Auto-Unlock (user-level systemd service)
# Usage:
#   ./tools/auto_unlock/install.sh install   # install + enable + start
#   ./tools/auto_unlock/install.sh uninstall # disable + remove

ACTION="${1:-install}"
SELF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DAEMON_SRC="$SELF_DIR/daemon.sh"
BIN_DST="$HOME/.local/bin/nadoo-key-auto-unlock"
UNIT_DIR="$HOME/.config/systemd/user"
UNIT_FILE="$UNIT_DIR/nadoo-key-auto-unlock.service"

best_effort_deps() {
  if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update -y || true
    sudo apt-get install -y zenity yubikey-manager fido2-tools || true
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y zenity yubikey-manager fido2-tools || true
  elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -Sy --noconfirm --needed zenity yubikey-manager fido2-tools || true
  else
    echo "[!] Unknown package manager; please ensure zenity, yubikey-manager, fido2-tools are installed."
  fi
}

install_service() {
  best_effort_deps
  mkdir -p "$HOME/.local/bin" "$UNIT_DIR"
  install -m 0755 "$DAEMON_SRC" "$BIN_DST"
  cat >"$UNIT_FILE" <<EOF
[Unit]
Description=NADOO-Key Auto-Unlock Agent (user session)
After=graphical-session.target

[Service]
Type=simple
ExecStart=%h/.local/bin/nadoo-key-auto-unlock
Restart=on-failure
RestartSec=3s

[Install]
WantedBy=default.target
EOF
  systemctl --user daemon-reload
  systemctl --user enable --now nadoo-key-auto-unlock.service
  echo "[✓] Auto-Unlock installed and started (user service)"
}

uninstall_service() {
  systemctl --user disable --now nadoo-key-auto-unlock.service 2>/dev/null || true
  rm -f "$UNIT_FILE" "$BIN_DST"
  systemctl --user daemon-reload || true
  echo "[✓] Auto-Unlock uninstalled"
}

case "$ACTION" in
  install) install_service ;;
  uninstall) uninstall_service ;;
  *) echo "Usage: $0 {install|uninstall}"; exit 1 ;;
 esac
