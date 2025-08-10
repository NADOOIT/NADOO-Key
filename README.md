# nadoo-key

Turn-key provisioning and registration of FIDO2 security keys on your system.

- One-button provisioning: reset (optional), initialize new PIN=0000 (optional), enroll fingerprints (optional), and register with sudo/login.
- Safe defaults: all destructive or PIN-related actions are opt-in.
- Linux supported now; macOS/Windows stubs included. Roadmap includes a simple UI.

## Install
Requirements (Ubuntu/Debian):
- libpam-u2f, udev
- curl, jq, coreutils

Get the code and run:
```bash
git clone https://github.com/NADOOIT/NADOO-Key.git nadoo-key
cd nadoo-key
sudo ./bin/nadoo-key provision   # guided provisioning
```

## Quick start (Linux)
```bash
cd nadoo-key
sudo ./bin/nadoo-key provision      # full guided provisioning (prompts)
# or
sudo ./bin/nadoo-key register       # just register this key with your computer
```

Options via env vars:
- REQUIRE_UV_LOGIN=0|1  → require fingerprint/PIN for login (default 0 → touch-only)
- REQUIRE_UV_SUDO=0|1   → require fingerprint/PIN for sudo (default 0 → touch-only)
- FINGERPRINTS=N        → auto-enroll N fingerprints on Bio keys

Examples:
```bash
REQUIRE_UV_LOGIN=1 REQUIRE_UV_SUDO=1 sudo ./bin/nadoo-key provision
FINGERPRINTS=5 sudo ./bin/nadoo-key provision
sudo ./bin/nadoo-key register
```

## Commands
- provision: full setup (packages → device detection → optional reset → optional init PIN=0000 → optional fingerprint enrollment → PAM registration for sudo/login)
- register: quick mapping and PAM login setup (adds this key like your other keys)
- reset: vendor reset of the FIDO2 application (erases credentials; use to recover from PIN lock)
- factory: batch provision many keys (with optional integration hook)

## Factory (batch provisioning)
Provision many keys in sequence; optional per-key integration with your IT service to pre-assign accounts.

Examples:
```bash
# Process 50 keys; no reset; no fingerprints; touch-only login (UV discouraged)
FACTORY_COUNT=50 sudo ./bin/nadoo-key factory

# Reset each key, enroll 2 fingerprints (Bio keys), and require fingerprint for sudo only
FACTORY_COUNT=10 FACTORY_RESET=1 FINGERPRINTS=2 REQUIRE_UV_SUDO=1 sudo ./bin/nadoo-key factory

# Integrate with external service per key (POST JSON), include a user hint
SERVICE_URL="https://api.example.com/fido/register" \
SERVICE_TOKEN="..." USER_HINT="john.doe@example.com" \
FACTORY_COUNT=100 sudo ./bin/nadoo-key factory
```

Behavior:
- Generates `factory/factory_log.csv` with per-key entries (serial/model if available).
- If `SERVICE_URL` is set, posts JSON per key via `scripts/integrations/service_register.sh`.
- If no `SERVICE_URL`, appends to `factory/service_queue.csv` for later processing.

Toggles:
- `REQUIRE_UV_LOGIN=0|1` login user-verification (default 0 → touch-only, no fingerprint)
- `REQUIRE_UV_SUDO=0|1`  sudo user-verification (default 0)
- `FINGERPRINTS=N`       auto-enroll N fingerprints on Bio keys
- `FACTORY_RESET=0|1`    reset FIDO2 app before provisioning keys (default 0)

## Defaults and UX
- Login/lock screen: touch-only by default (no fingerprint/PIN) to avoid biometric lockouts; `max_devices=1` for fast detection. Enable fingerprints by setting `REQUIRE_UV_LOGIN=1`.
- Sudo: touch-only by default; enable fingerprints via `REQUIRE_UV_SUDO=1`.
- Hot-plug autoload: udev/systemd helper wakes the greeter when the key is inserted.

## Troubleshooting (snapshot)
- GNOME login/lock screen: ensure mapping file exists (`~/.config/Yubico/u2f_keys` or `/etc/u2f_keys`) with correct permissions; `openasuser` is configured where required.
- Device state: if a Bio key flashes red, unlock with PIN once to clear biometric lockout; default policy avoids fingerprint requirements.
- Hot-plug: `max_devices=1` and the helper allow plugging the key after greeter appears; press Enter if needed.

## Onboarding & Runbook
- Read-first team overview: `docs/handouts/read_first_fido2_rollout_guide.md`
- One-day event runbook (up to 500 users): `docs/marketing/social_kit/event_runbook_1day_500.md`
- Full work plan: `docs/work_plan.md`

## Verification and rerun
- After each run, the scripts perform quick checks (device present, U2F mapping file exists, pam_u2f configured).
- If an issue is detected, you’ll be prompted: “An error was detected. Rerun this script now? [y/N]”. Choose y to retry.
- PIN presence is also checked and warned about (recommended: 0000 for new keys during initialization).

## Support
- If you need help, contact: Christoph Backhaus

## Roadmap
- Cross-platform parity (macOS `pam_u2f` for sudo; Windows Hello/Entra flows)
- Simple TUI/GUI for one-click provisioning
- Optional local vault unlocked by FIDO2 (LUKS2 wrapper)

## License
MIT
