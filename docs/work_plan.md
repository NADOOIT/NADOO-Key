# FIDO2 Rollout Work Plan (Standalone)

This is a concise in-repo plan tailored to the `nadoo-key` CLI. Use it as a quick reference during planning and rollout.

## Scope & Objectives
- Provision FIDO2 keys on Linux and register for login + sudo via `pam_u2f`.
- Default UX: touch-only (no fingerprint/PIN) to avoid biometric lockouts.
- Optional UV (fingerprint/PIN) per environment via `REQUIRE_UV_LOGIN` / `REQUIRE_UV_SUDO`.

## Roles
- Executive sponsor, IT lead, Station leads, Runners, Helpdesk.

## Timeline (high level)
- T-7 to T-1: announce, pilot (10 users), station prep.
- Day 0: waves of 20–30 every 30–45 min, CSV logging + spot verification.
- T+1/T+7: latecomers, metrics, lessons learned.

## Commands (examples)
```bash
# Guided provisioning for a single device
sudo ./bin/nadoo-key provision

# Factory provisioning (touch-only defaults)
FACTORY_COUNT=50 sudo ./bin/nadoo-key factory

# Require fingerprint at login and sudo (if desired)
REQUIRE_UV_LOGIN=1 REQUIRE_UV_SUDO=1 sudo ./bin/nadoo-key provision
```

## Integration (optional)
- Per-key registration hook: `scripts/integrations/service_register.sh`
- Provide `SERVICE_URL`, `SERVICE_TOKEN`, `USER_HINT` to enable API posting.

## Acceptance Criteria
- Login and sudo work via the FIDO2 key (touch-only by default).
- CSV `factory/factory_log.csv` complete and accurate.
- GNOME greeter hot-plug works (`max_devices=1`); mapping path/permissions correct.
- Handouts provided to users; helpdesk briefed.

## Links
- Read-first: `handouts/read_first_fido2_rollout_guide.md`
- Event runbook (1-day): `marketing/social_kit/event_runbook_1day_500.md`
