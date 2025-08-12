#!/usr/bin/env bash
set -Eeuo pipefail

# macOS launcher for NADOO‑Key provisioning from the USB root.
# Note: macOS supports WebAuthn/passkeys in browsers and pam_u2f for sudo, but
# native OS login with FIDO2 security keys is not supported.

cd "$(dirname "$0")"
REPO_DIR="$(pwd)/nadoo-key"

cat <<'MSG'
[+] NADOO‑Key (macOS)
- Passkeys/WebAuthn: supported in Safari/Chrome/Firefox.
- OS login with FIDO2 keys: not supported by macOS.
- Advanced: pam_u2f for sudo is possible (developer/IT only).

Proceeding to run the macOS provisioning stub for guidance...
MSG

if [[ -x "$REPO_DIR/scripts/macos/provision.sh" ]]; then
  "$REPO_DIR/scripts/macos/provision.sh" || true
else
  echo "[x] Not found: $REPO_DIR/scripts/macos/provision.sh"
fi

echo
read -r -p "Press Enter to open the README (optional) ..." _ || true
open "$REPO_DIR/README.md" 2>/dev/null || true
