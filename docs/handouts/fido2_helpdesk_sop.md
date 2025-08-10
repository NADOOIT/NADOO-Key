# Helpdesk SOP – FIDO2

Audience: IT support / service desk

## Triage checklist
- Is the key present? `lsusb` or try replug; different port.
- Linux login/sudo configured? Check pam_u2f lines in `/etc/pam.d/login`, DM files, and `/etc/pam.d/sudo`.
- Mapping file exists? `~/.config/Yubico/u2f_keys` is present and non‑empty.
- Fingerprint lockout? Prompt user for PIN once to clear.

## Common fixes
- Re‑register key mapping: `sudo ./nadoo-key/bin/nadoo-key register`
- Re‑provision user: `sudo ./nadoo-key/bin/nadoo-key provision`
- Refresh PAM options (touch‑only vs fingerprint): set `REQUIRE_UV_LOGIN`/`REQUIRE_UV_SUDO` and rerun provisioning with `FORCE=1`.
- Device rules: run provisioning to reload udev; verify `libfido2`, `pam_u2f` packages.

## Replace or add key
1) Issue backup key.
2) Register: `sudo ./nadoo-key/bin/nadoo-key register` (user touches key).
3) Remove old mapping if needed.

## Factory mode (batch)
- Command: `FACTORY_COUNT=N sudo ./nadoo-key/bin/nadoo-key factory`
- Options: `FACTORY_RESET=1`, `FINGERPRINTS=N`, `SERVICE_URL=...` (per‑key API), `OUTPUT_CSV=...`

## Escalation
- If PAM edits didn’t apply, collect:
  - PAM files touched, mapping path, file permissions, device logs
- Escalate to: Christoph Backhaus / Security Engineering
