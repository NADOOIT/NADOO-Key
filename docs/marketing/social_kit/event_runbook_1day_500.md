# Event Runbook – One‑Day Rollout (Up to 500 Users)

Goal
- Provision up to 500 FIDO2 keys and complete Linux login + sudo setup in a single day.

Team & Roles
- Lead Engineer (LE), Key Station Leads (KSL ×4), Runners (2), Helpdesk Liaison (1), Comms (1).

Pre‑Day (T‑7 to T‑1)
- Confirm hardware (2 keys/user if policy). Label batches by team.
- Prep CSV template (name, email, username, key serial, timestamp).
- Test venue power/USB hubs; print handouts; prep signage.
- Confirm SERVICE_URL for integration (if any); test API.

Day‑of Timeline
- 08:00 Setup stations (4 stations × ~125 users each)
- 09:00 Kickoff + policy briefing (15m)
- 09:15 Pilot validation (10 users) → Go/No‑Go
- 09:45 Wave 1 (125 users)
- 11:00 Wave 2 (125 users)
- 12:00 Lunch / buffer / troubleshooting
- 13:00 Wave 3 (125 users)
- 14:15 Wave 4 (125 users)
- 16:00 Final verification, reports, handoff

Station Procedure (per user)
1) Insert key → `nadoo-key provision` (defaults: PIN 0000 for new; touch‑only login; UV optional)
2) Verify sudo + lock screen; capture mapping line
3) CSV log: user, serial, status; optional POST to SERVICE_URL

Checklists
- Power, USB hubs, extra cables/adapters, spare keys, printed QR to docs, signage.
- Spare laptops with Linux, admin rights, internet fallback.

Risk & Mitigation
- Bottlenecks → 4 stations + runners; pre‑brief users on steps.
- Fingerprint lockouts → default touch‑only; PIN unlock SOP ready.
- API downtime → queue events and retry after.

Aftercare
- Deliver CSV + report; transfer SOPs; schedule follow‑up check.
