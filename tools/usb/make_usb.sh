#!/usr/bin/env bash
set -Eeuo pipefail

# make_usb.sh — Prepare a cross‑platform NADOO‑Key installer USB from this repo.
# Usage: tools/usb/make_usb.sh /path/to/usb/mountpoint
#
# What it does:
# - Copies payload starters to the USB root (Linux/macOS/Windows launchers)
# - Copies required repo content to /nadoo-key on the USB (scripts, bin)
# - Sets executable bits as needed
# - Writes a label file and optional autorun.inf (Windows label only)
#
# Note: Modern OSes block auto‑run from USB by design. Users must double‑click
# the starter appropriate for their OS after inserting the stick.

main() {
  if [[ $# -ne 1 ]]; then
    echo "Usage: $0 /path/to/usb/mountpoint" >&2; exit 1
  fi
  local USB_ROOT="$1"
  if [[ ! -d "$USB_ROOT" ]]; then
    echo "Mount point not found: $USB_ROOT" >&2; exit 1
  fi
  local REPO_ROOT
  REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"

  echo "[+] Preparing USB at: $USB_ROOT"

  # Create structure
  mkdir -p "$USB_ROOT/nadoo-key"

  # Copy repo essentials
  rsync -a --delete \
    "$REPO_ROOT/scripts/" "$USB_ROOT/nadoo-key/scripts/"
  rsync -a --delete \
    "$REPO_ROOT/bin/" "$USB_ROOT/nadoo-key/bin/"

  # Optional: include handouts for offline reference
  if [[ -d "$REPO_ROOT/docs/handouts" ]]; then
    mkdir -p "$USB_ROOT/nadoo-key/docs/handouts"
    rsync -a "$REPO_ROOT/docs/handouts/" "$USB_ROOT/nadoo-key/docs/handouts/"
  fi

  # Copy payload starters to USB root
  local PAYLOAD="$REPO_ROOT/tools/usb/payload"
  install -m 0644 "$PAYLOAD/README.txt" "$USB_ROOT/README.txt"
  install -m 0755 "$PAYLOAD/start_linux.sh" "$USB_ROOT/start_linux.sh"
  install -m 0755 "$PAYLOAD/Start NADOO-Key Installer.command" "$USB_ROOT/Start NADOO-Key Installer.command"
  install -m 0644 "$PAYLOAD/Start-NADOO-Key-Installer.desktop" "$USB_ROOT/Start-NADOO-Key-Installer.desktop"
  install -m 0644 "$PAYLOAD/autorun.inf" "$USB_ROOT/autorun.inf" || true
  install -m 0644 "$PAYLOAD/Start-NADOO-Key-Installer.cmd" "$USB_ROOT/Start-NADOO-Key-Installer.cmd"
  install -m 0644 "$PAYLOAD/start_windows.ps1" "$USB_ROOT/start_windows.ps1"

  # Ensure executables
  chmod +x "$USB_ROOT/start_linux.sh" || true
  chmod +x "$USB_ROOT/Start NADOO-Key Installer.command" || true

  # Write a volume label marker (cross‑platform friendly text file)
  echo "NADOO-KEY" > "$USB_ROOT/VOLUME_LABEL.txt"

  echo "[+] USB prepared. Contents:"
  find "$USB_ROOT" -maxdepth 2 -mindepth 1 -printf "%P\n" | sed 's/^/    /'
  echo "\nNext: Safely eject the drive. On target machines, double‑click the starter for the OS:"
  echo " - Linux: start_linux.sh (or .desktop on some distros: right‑click → Run as Program)"
  echo " - macOS: Start NADOO-Key Installer.command"
  echo " - Windows: Start-NADOO-Key-Installer.cmd"
}

main "$@"
