# Read First: FIDO2 Rollout Guide

Audience: IT leads, helpdesk, and rollout crew.

## What this repo provides
- nadoo-key CLI for one-click FIDO2 provisioning and login/sudo registration on Linux.
- Factory mode for batch provisioning with CSV logging and optional integration hook.
- Safe defaults: touch-only login to avoid biometric lockouts; fingerprint optional.

## Quick start
```bash
sudo ./bin/nadoo-key provision
```
- New keys: set PIN=0000 when prompted (recommended for factory/new).
- Bio keys: enroll fingerprints only if you set `FINGERPRINTS=N` or `REQUIRE_UV_*=1`.

## Factory provisioning
```bash
FACTORY_COUNT=50 sudo ./bin/nadoo-key factory
```
Toggles: `REQUIRE_UV_LOGIN`, `REQUIRE_UV_SUDO`, `FINGERPRINTS`, `FACTORY_RESET`, integration via `scripts/integrations/service_register.sh`.

## Troubleshooting
- GNOME login/lock: ensure PAM mapping exists and permissions are correct; `openasuser` where needed.
- Bio red light: unlock once with PIN to clear biometric lockout.
- Hot-plug: helper + `max_devices=1` supports insert-after-greeter; press Enter if needed.

## Links
- Work plan: `../work_plan.md`
- Event runbook: `../marketing/social_kit/event_runbook_1day_500.md`
- Vault concept: `../VAULT.md`
