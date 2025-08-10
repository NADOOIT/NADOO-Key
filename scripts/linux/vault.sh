#!/usr/bin/env bash
set -Eeuo pipefail

# Manage a LUKS2 vault file unlocked by a FIDO2 key.
# Subcommands: create|open|close|status
# Example:
#   sudo ./bin/nadoo-key vault create --size 2G --mount ~/NADOO_Vault

VAULT_NAME=${VAULT_NAME:-nadoo_vault}
VAULT_DIR=${VAULT_DIR:-$HOME/.local/share/nadoo_vault}
VAULT_FILE=${VAULT_FILE:-$VAULT_DIR/vault.luks}
MOUNT_POINT_DEFAULT=${MOUNT_POINT_DEFAULT:-$HOME/NADOO_Vault}

log() { echo -e "[+] $*"; }
warn() { echo -e "[!] $*"; }
err() { echo -e "[x] $*" >&2; }

usage() {
  cat <<EOF
Usage: nadoo-key vault <create|open|close|status> [options]

create  --size <SIZE> [--mount <DIR>]
open    [--mount <DIR>]
close   [--mount <DIR>]
status

Environment:
  VAULT_NAME (default: nadoo_vault)
  VAULT_DIR  (default: ~/.local/share/nadoo_vault)
  VAULT_FILE (default: VAULT_DIR/vault.luks)
EOF
}

need_root() { [[ $EUID -eq 0 ]] || { err "Run with sudo/root"; exit 1; }; }

parse_mount_arg() {
  local mp="$1"; [[ -n "$mp" ]] || mp="$MOUNT_POINT_DEFAULT"; echo "$mp"
}

create_vault() {
  local size=""; local mount=""
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --size) size="$2"; shift 2;;
      --mount) mount="$2"; shift 2;;
      *) err "Unknown option: $1"; exit 1;;
    esac
  done
  [[ -n "$size" ]] || { err "--size is required (e.g., 2G)"; exit 1; }
  [[ -n "$mount" ]] || mount="$MOUNT_POINT_DEFAULT"

  mkdir -p "$VAULT_DIR"
  if command -v fallocate >/dev/null 2>&1; then
    fallocate -l "$size" "$VAULT_FILE"
  else
    dd if=/dev/zero of="$VAULT_FILE" bs=1M count=0 seek=$(numfmt --from=iec "$size")
  fi
  log "Vault file created at $VAULT_FILE"

  log "Formatting as LUKS2 (you will be asked to set a recovery passphrase)..."
  cryptsetup luksFormat --type luks2 "$VAULT_FILE"

  log "Enrolling FIDO2 key (touch when it blinks)..."
  systemd-cryptenroll --fido2-device=auto "$VAULT_FILE"

  log "Creating filesystem..."
  cryptsetup open "$VAULT_FILE" ${VAULT_NAME}_temp
  mkfs.ext4 -q "/dev/mapper/${VAULT_NAME}_temp"
  cryptsetup close ${VAULT_NAME}_temp

  mkdir -p "$mount"
  log "Vault created. Use: sudo ./bin/nadoo-key vault open --mount $mount"
}

open_vault() {
  local mount="$(parse_mount_arg "$1")"
  mkdir -p "$mount"
  log "Unlocking (touch the key)..."
  systemd-cryptsetup attach "$VAULT_NAME" "$VAULT_FILE" || { err "Failed to open. Try your recovery passphrase via: cryptsetup open $VAULT_FILE $VAULT_NAME"; exit 1; }
  mount "/dev/mapper/$VAULT_NAME" "$mount"
  log "Mounted at $mount"
}

close_vault() {
  local mount="$(parse_mount_arg "$1")"
  if mountpoint -q "$mount"; then
    umount "$mount"
  fi
  if [ -e "/dev/mapper/$VAULT_NAME" ]; then
    systemd-cryptsetup detach "$VAULT_NAME" || cryptsetup close "$VAULT_NAME" || true
  fi
  log "Closed vault."
}

status_vault() {
  if [ -e "/dev/mapper/$VAULT_NAME" ]; then
    echo "Mapper open: /dev/mapper/$VAULT_NAME"
  else
    echo "Mapper closed."
  fi
  ls -lh "$VAULT_FILE" 2>/dev/null || true
}

main() {
  need_root
  local cmd="${1:-}"; shift || true
  case "$cmd" in
    create) create_vault "$@";;
    open)   open_vault "$@";;
    close)  close_vault "$@";;
    status) status_vault;;
    *) usage; exit 1;;
  esac
}

main "$@"
