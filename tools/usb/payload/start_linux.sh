#!/usr/bin/env bash
set -Eeuo pipefail

# start_linux.sh — Launch NADOO‑Key provisioning on Linux from the USB root.
# Requires: internet for package install, sudo rights.

self_dir() { local s="${BASH_SOURCE[0]}"; cd "$(dirname "${s}")" >/dev/null 2>&1 && pwd; }
SCRIPT_DIR="$(self_dir)"
REPO_DIR="$SCRIPT_DIR/nadoo-key"

if [[ ! -d "$REPO_DIR/scripts/linux" ]]; then
  echo "[x] Could not find nadoo-key/scripts/linux on the USB. Rebuild the USB with tools/usb/make_usb.sh." >&2
  exit 1
fi

# Re-exec as root, preserving environment toggles if the user set them.
if [[ $EUID -ne 0 ]]; then
  echo "[+] Elevating privileges (sudo) ..."
  exec sudo -E "$0" "$@"
fi

# Defaults optimized for smooth rollouts
export REQUIRE_UV_LOGIN="${REQUIRE_UV_LOGIN:-0}"
export REQUIRE_UV_SUDO="${REQUIRE_UV_SUDO:-0}"
export FINGERPRINTS="${FINGERPRINTS:-0}"

echo "[+] NADOO‑Key Linux provisioning will install required packages and configure PAM (sudo + login)."
echo "[+] Defaults: touch‑only login (fingerprint optional), PIN=0000 on new keys."

cd "$REPO_DIR/scripts/linux"
./provision.sh || {
  echo "[x] Provisioning failed. See above logs." >&2
  exit 1
}

echo
echo "[✓] Provisioning complete. You can now remove this USB stick and insert your FIDO2 key when prompted by the system (lock screen/sudo)."
