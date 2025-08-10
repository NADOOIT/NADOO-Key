#!/usr/bin/env bash
set -Eeuo pipefail

# Common library for nadoo-key Linux scripts

if [[ "${LC_ALL:-}" != "C" ]]; then export LC_ALL=C; fi

log() { echo -e "[+] $*"; }
warn() { echo -e "[!] $*"; }
err() { echo -e "[x] $*" >&2; }

# Support contact (customize as needed)
support_contact() {
  echo "If you need help, contact: Christoph Backhaus"
}

require_root() {
  if [[ $EUID -ne 0 ]]; then
    if command -v sudo >/dev/null 2>&1; then
      sudo -v || { err "sudo privileges are required"; exit 1; }
      SUDO=sudo
    else
      err "Please run as root or install sudo"; exit 1
    fi
  else
    SUDO=""
  fi
}

prompt_yes_no() {
  local q="${1:-Confirm? [y/N]}"
  local ans=""
  read -r -p "$q " ans || true
  [[ "$ans" == "y" || "$ans" == "Y" ]] && return 0 || return 1
}

has_pin_set() {
  # Try via ykman
  if command -v ykman >/dev/null 2>&1; then
    local info
    info=$(ykman fido info 2>/dev/null || true)
    if echo "$info" | grep -qiE 'pin[^\n]*is[^\n]*set[^:]*: *([ty]rue|yes|1)'; then
      return 0
    fi
  fi
  # Fallback via fido2-tools
  if command -v fido2-token >/dev/null 2>&1; then
    local dev
    dev=$(fido2-token -L 2>/dev/null | awk '/^\/dev\/hidraw/{print $1; exit}')
    if [[ -n "$dev" ]]; then
      local inf
      inf=$(fido2-token -I "$dev" 2>/dev/null || true)
      if echo "$inf" | grep -qiE 'pin[^\n]*set[^:]*: *([ty]rue|yes|1)'; then
        return 0
      fi
    fi
  fi
  return 1
}

wait_for_device() {
  local tries=60
  while ((tries--)); do
    if command -v fido2-token >/dev/null 2>&1; then
      local devs
      devs=$(fido2-token -L 2>/dev/null | awk '/^\/dev\/hidraw/{print $1}') || true
      if [[ -n "$devs" ]]; then
        echo "$devs"; return 0
      fi
    fi
    sleep 1
  done
  return 1
}

reset_fido2_app() {
  if ! command -v ykman >/dev/null 2>&1; then
    warn "ykman not found; cannot reset via vendor tool. Skipping reset."; return 0
  fi
  warn "About to RESET FIDO2 application (erases all FIDO credentials)."
  ykman fido reset || { err "Reset failed."; return 1; }
  log "Re-plug the key if prompted; waiting for device..."
  wait_for_device || true
}

init_new_key_pin() {
  if command -v ykman >/dev/null 2>&1; then
    # First attempt: non-interactive change to 0000 (works when PIN is not set)
    if ! has_pin_set; then
      if ykman fido access change-pin -n 0000 >/dev/null 2>&1; then
        log "FIDO2 PIN set to 0000."
        return 0
      fi
    fi
    # If supported, try explicit set-pin (older ykman may not have it)
    if ykman fido access -h 2>/dev/null | grep -q 'set-pin'; then
      /usr/bin/expect <<'EOF' || true
set timeout 30
spawn ykman fido access set-pin
expect {
  -re "(Enter.*new PIN|New PIN).*" { send "0000\r"; exp_continue }
  -re "(Repeat|Confirm).*" { send "0000\r"; exp_continue }
  eof
}
EOF
      if has_pin_set; then
        log "FIDO2 PIN appears set."
        return 0
      fi
    fi
    # Fallback: change-pin with empty current (in case set-pin unsupported)
    /usr/bin/expect <<'EOF' || true
set timeout 30
spawn ykman fido access change-pin
expect {
  -re "Enter your current PIN.*" { send "\r"; exp_continue }
  -re "(Enter.*new PIN|New PIN).*" { send "0000\r"; exp_continue }
  -re "(Repeat|Confirm).*" { send "0000\r"; exp_continue }
  eof
}
EOF
  fi
  if has_pin_set; then
    log "FIDO2 PIN appears set."
    return 0
  else
    # Stay quiet here; post_check() will warn if needed.
    return 0
  fi
}

detect_pkg_mgr() {
  if command -v apt-get >/dev/null 2>&1; then
    PKG=apt
  elif command -v dnf >/dev/null 2>&1; then
    PKG=dnf
  elif command -v pacman >/dev/null 2>&1; then
    PKG=pacman
  else
    err "Unsupported distro: need apt, dnf, or pacman"; exit 1
  fi
}

install_pkgs() {
  case "$PKG" in
    apt)
      $SUDO apt-get update -y
      $SUDO apt-get install -y libfido2-1 fido2-tools libu2f-udev libpam-u2f yubikey-manager expect curl jq || true
      ;;
    dnf)
      $SUDO dnf install -y libfido2 fido2-tools pam_u2f yubikey-manager expect curl jq || true
      $SUDO dnf install -y ykman || true
      ;;
    pacman)
      $SUDO pacman -Sy --noconfirm --needed libfido2 pam_u2f yubikey-manager expect curl jq || true
      $SUDO pacman -S --noconfirm --needed fido2-tools || true
      ;;
  esac
  $SUDO udevadm control --reload-rules || true
  $SUDO udevadm trigger || true
}

post_check() {
  local failed=0

  # Check device is visible
  if ! wait_for_device >/dev/null; then
    warn "No FIDO2 device detected after setup."
    failed=1
  fi

  # Check mapping file exists and non-empty
  local target_user target_home u2f_file
  target_user="${SUDO_USER:-$USER}"
  target_home=$(getent passwd "$target_user" | cut -d: -f6)
  u2f_file="$target_home/.config/Yubico/u2f_keys"
  if [[ ! -s "$u2f_file" ]]; then
    warn "Missing or empty mapping file: $u2f_file"
    failed=1
  fi

  # Check pam_u2f in sudo
  if ! grep -q "pam_u2f.so" /etc/pam.d/sudo; then
    warn "pam_u2f not present in /etc/pam.d/sudo"
    failed=1
  fi

  # Optional: PIN presence (warn only)
  if ! has_pin_set; then
    warn "FIDO2 PIN not set. Initialize with PIN=0000 for full functionality."
  fi

  if [[ $failed -eq 0 ]]; then
    log "Verification passed."
    return 0
  else
    err "One or more checks failed."
    return 1
  fi
}

offer_rerun() {
  local ans=""
  echo
  read -r -p "An error was detected. Rerun this script now? [y/N] " ans || true
  if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
    if [[ -n "${ORIGINAL_ARGS+x}" ]]; then
      exec "$0" "${ORIGINAL_ARGS[@]}"
    else
      exec "$0"
    fi
  fi
  echo
  support_contact
}

enroll_fingerprint_if_bio() {
  if ! command -v ykman >/dev/null 2>&1; then return 0; fi
  if ykman list 2>/dev/null | grep -iq 'bio'; then
    log "Fingerprint-capable key detected."
    local fp_method=""
    if ykman fido fingerprints --help >/dev/null 2>&1; then
      fp_method="fido"
    elif ykman bio --help >/dev/null 2>&1; then
      fp_method="bio"
    else
      warn "Fingerprint enrollment commands not available in ykman. Skipping."
      return 0
    fi
    local requested="${FINGERPRINTS:-}"
    if [[ -n "$requested" && "$requested" =~ ^[0-9]+$ && "$requested" -gt 0 ]]; then
      log "Auto-enrolling $requested fingerprint(s). Touch the sensor when prompted."
      local i
      for ((i=1; i<=requested; i++)); do
        log "Enrolling fingerprint #$i..."
        log "Touch the sensor now and follow prompts (several touches may be required)..."
        if [[ "$fp_method" == "fido" ]]; then
          ykman fido fingerprints add "Finger $i" --pin 0000 \
            || ykman fido fingerprints add "Finger $i" \
            || warn "Fingerprint #$i enrollment skipped or failed."
        else
          ykman bio enroll || warn "Fingerprint #$i enrollment skipped or failed."
        fi
      done
    else
      log "Interactive fingerprint enrollment (up to 5)."
      log "Type 'y' then Enter to enroll. Press Enter to skip. Type 's' then Enter to stop."
      local i ans
      for i in 1 2 3 4 5; do
        read -r -p "Enroll fingerprint #$i? [y=yes / Enter=skip / s=stop] " ans || true
        if [[ "$ans" == "s" || "$ans" == "S" ]]; then
          break
        fi
        if [[ -z "$ans" ]]; then
          continue
        fi
        if [[ "$ans" != "y" && "$ans" != "Y" ]]; then
          continue
        fi
        log "Enrolling fingerprint #$i..."
        log "Touch the sensor now and follow prompts (several touches may be required)..."
        if [[ "$fp_method" == "fido" ]]; then
          ykman fido fingerprints add "Finger $i" --pin 0000 \
            || ykman fido fingerprints add "Finger $i" \
            || warn "Fingerprint #$i enrollment skipped or failed."
        else
          ykman bio enroll || warn "Fingerprint #$i enrollment skipped or failed."
        fi
      done
    fi
  else
    log "No fingerprint-capable key detected."
  fi
}

configure_login_pam() {
  local control
  if [[ "${REQUIRE_U2F:-0}" == "1" ]]; then control="required"; else control="sufficient"; fi
  local pam_line
  # Separate toggle for login: REQUIRE_UV_LOGIN (falls back to REQUIRE_UV)
  local _uv_login="${REQUIRE_UV_LOGIN:-${REQUIRE_UV:-0}}"
  if [[ "${_uv_login}" == "1" ]]; then
    pam_line="auth ${control} pam_u2f.so cue userverification=required max_devices=1 authfile=/home/%u/.config/Yubico/u2f_keys"
  else
    pam_line="auth ${control} pam_u2f.so cue userverification=discouraged max_devices=1 authfile=/home/%u/.config/Yubico/u2f_keys"
  fi
  if [[ -f /etc/pam.d/login ]]; then
    if ! grep -q "pam_u2f.so" /etc/pam.d/login; then
      local backup_login="/etc/pam.d/login.bak.fido.$(date +%s)"
      $SUDO cp /etc/pam.d/login "$backup_login"
      $SUDO sed -i "1i ${pam_line}" /etc/pam.d/login
      log "Updated /etc/pam.d/login (backup at $backup_login)"
    else
      log "pam_u2f already present in /etc/pam.d/login; leaving as-is."
    fi
  fi
  local dm=""
  if [[ -f /etc/X11/default-display-manager ]]; then
    dm=$(basename "$(cat /etc/X11/default-display-manager 2>/dev/null || true)" 2>/dev/null || true)
  else
    dm=$(basename "$(readlink -f /etc/systemd/system/display-manager.service 2>/dev/null || true)" 2>/dev/null || true)
  fi
  local pam_targets=()
  case "$dm" in
    gdm|gdm3|gdm-wayland|gdm-xorg) pam_targets+=("/etc/pam.d/gdm-password") ;;
    sddm) pam_targets+=("/etc/pam.d/sddm") ;;
    lightdm) pam_targets+=("/etc/pam.d/lightdm") ;;
  esac
  for f in "${pam_targets[@]}"; do
    if [[ -f "$f" ]]; then
      if ! grep -q "pam_u2f.so" "$f"; then
        local backup_dm="$f.bak.fido.$(date +%s)"
        $SUDO cp "$f" "$backup_dm"
        $SUDO sed -i "1i ${pam_line}" "$f"
        log "Updated $f (backup at $backup_dm)"
      else
        # If FORCE=1, replace existing pam_u2f line to sync options
        if [[ "${FORCE:-0}" == "1" ]]; then
          local backup_dm2="$f.bak.fido.$(date +%s)"
          $SUDO cp "$f" "$backup_dm2"
          $SUDO sed -i -E 's|^auth .* pam_u2f\.so.*$|'"${pam_line}"'|' "$f"
          log "Replaced existing pam_u2f line in $f (backup at $backup_dm2)"
        else
          log "pam_u2f already present in $f; leaving as-is. Set FORCE=1 to update options."
        fi
      fi
    fi
  done
  # GNOME lock screen service, if present on some distros
  if [[ -f /etc/pam.d/gnome-screensaver ]]; then
    if ! grep -q "pam_u2f.so" /etc/pam.d/gnome-screensaver; then
      local backup_gs="/etc/pam.d/gnome-screensaver.bak.fido.$(date +%s)"
      $SUDO cp /etc/pam.d/gnome-screensaver "$backup_gs"
      $SUDO sed -i "1i ${pam_line}" /etc/pam.d/gnome-screensaver
      log "Updated /etc/pam.d/gnome-screensaver (backup at $backup_gs)"
    else
      log "pam_u2f already present in /etc/pam.d/gnome-screensaver; leaving as-is."
    fi
  fi
  # GNOME Shell (some distros ship a separate PAM file)
  if [[ -f /etc/pam.d/gnome-shell ]]; then
    if ! grep -q "pam_u2f.so" /etc/pam.d/gnome-shell; then
      local backup_gsh="/etc/pam.d/gnome-shell.bak.fido.$(date +%s)"
      $SUDO cp /etc/pam.d/gnome-shell "$backup_gsh"
      $SUDO sed -i "1i ${pam_line}" /etc/pam.d/gnome-shell
      log "Updated /etc/pam.d/gnome-shell (backup at $backup_gsh)"
    else
      log "pam_u2f already present in /etc/pam.d/gnome-shell; leaving as-is."
    fi
  fi
}

setup_pam_u2f() {
  local target_user target_home u2f_file pam_file backup
  target_user="${SUDO_USER:-$USER}"
  target_home=$(getent passwd "$target_user" | cut -d: -f6)
  if [[ -z "$target_home" || ! -d "$target_home" ]]; then
    err "Could not resolve home for user $target_user"; exit 1
  fi
  mkdir -p "$target_home/.config/Yubico"
  chown -R "$target_user":"$target_user" "$target_home/.config"
  u2f_file="$target_home/.config/Yubico/u2f_keys"
  local action=""; [[ -f "$u2f_file" ]] && action="-n"
  log "Registering U2F mapping for user $target_user (touch the key when it blinks)..."
  if ! sudo -u "$target_user" pamu2fcfg $action > >(sudo -u "$target_user" tee -a "$u2f_file" >/dev/null); then
    warn "pamu2fcfg failed; ensure the key is plugged in and touch it when prompted."
  fi
  chmod 600 "$u2f_file" 2>/dev/null || true
  chown "$target_user":"$target_user" "$u2f_file" 2>/dev/null || true
  pam_file="/etc/pam.d/sudo"
  backup="/etc/pam.d/sudo.bak.fido.$(date +%s)"
  if ! grep -q "pam_u2f.so" "$pam_file"; then
    $SUDO cp "$pam_file" "$backup"
    # Separate toggle for sudo: REQUIRE_UV_SUDO (falls back to REQUIRE_UV)
    local _uv_sudo="${REQUIRE_UV_SUDO:-${REQUIRE_UV:-0}}"
    if [[ "${_uv_sudo}" == "1" ]]; then
      $SUDO sed -i '1i auth sufficient pam_u2f\.so cue userverification=required authfile=/home/%u/.config/Yubico/u2f_keys' "$pam_file"
    else
      $SUDO sed -i '1i auth sufficient pam_u2f\.so cue userverification=discouraged authfile=/home/%u/.config/Yubico/u2f_keys' "$pam_file"
    fi
    log "Updated $pam_file (backup at $backup)"
  else
    if [[ "${FORCE:-0}" == "1" ]]; then
      $SUDO cp "$pam_file" "$backup"
      local _uv_sudo2="${REQUIRE_UV_SUDO:-${REQUIRE_UV:-0}}"
      if [[ "${_uv_sudo2}" == "1" ]]; then
        $SUDO sed -i -E 's|^auth .* pam_u2f\.so.*$|auth sufficient pam_u2f.so cue userverification=required authfile=/home/%u/.config/Yubico/u2f_keys|' "$pam_file"
      else
        $SUDO sed -i -E 's|^auth .* pam_u2f\.so.*$|auth sufficient pam_u2f.so cue userverification=discouraged authfile=/home/%u/.config/Yubico/u2f_keys|' "$pam_file"
      fi
      log "Replaced existing pam_u2f line in $pam_file (backup at $backup)"
    else
      log "pam_u2f already present in $pam_file; leaving as-is. Set FORCE=1 to update options."
    fi
  fi
}
