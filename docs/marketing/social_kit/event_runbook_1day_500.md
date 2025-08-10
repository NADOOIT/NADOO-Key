# Event Runbook: One-Day FIDO2 Rollout (up to 500 users)

Audience: Station leads, runners, helpdesk, comms.

## Goals
- Provision keys, register for login+sudo, and hand off within one working day.
- Touch-only UX by default (fingerprint optional) to avoid biometric lockouts.

## Roles
- Executive sponsor, IT lead, Station leads (A/B/C), Runners, Helpdesk, Comms.

## Timeline (suggested)
- T-7: Announce, pre-reads, dry run (10-user pilot).
- T-1: Prep stations, test greeter hot-plug, print signage.
- Day 0: Waves of 20–30 every 30–45 min; monitor dashboards and CSV.
- T+1/T+7: Follow-ups, latecomers, metrics.

## Stations
- A: Welcome & identity check.
- B: Provisioning (nadoo-key CLI). Suggested:
  ```bash
  FACTORY_COUNT=50 sudo ./bin/nadoo-key factory
  ```
- C: Verification (login lock screen + sudo test), handout, support.

## Checklists
- Devices: powered hubs, spare cables, signage.
- Software: libpam-u2f, udev, curl, jq present.
- PAM: mapping path valid, permissions correct, `openasuser` where required.
- Greeter: hot-plug helper active, `max_devices=1`.

## Troubleshooting
- Red flashing Bio key: unlock with PIN once to clear lockout.
- Mapping errors: ensure `~/.config/Yubico/u2f_keys` or `/etc/u2f_keys` exists and is readable.
- If integration API down: queue to `factory/service_queue.csv` and retry after.

## Artifacts
- CSV: `factory/factory_log.csv`.
- Optional: `factory/service_queue.csv` for deferred integration.

## Contact
- Support: Christoph Backhaus
