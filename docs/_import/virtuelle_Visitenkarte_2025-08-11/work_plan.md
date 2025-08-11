# Project Work Plan

This plan helps both new users and developers quickly understand the system and accomplish tasks.

## Overview of Features
- Export Koko Analytics data via Selenium (admin export)
- Alternative REST-based exporter (no Selenium)
- Extract ZIP, locate `event-click-tracker*.csv`
- Analyze with pandas and render charts with matplotlib
- Tkinter dashboards over extracted CSVs
- Optional email report with chart attachment
- Local Flask harness simulating invite/unique-link flow
- Web UI migration to Jinja templates (served by Flask)
- Tests, coverage suggestions, data-safety hints, and security checks

## Daily Flow (developers)
- Activate venv, install deps first time
- Run default workflow:
  ```bash
  make
  ```
  This runs safety suggestions and the test suite with coverage.
- Optionally, run the local harness:
  ```bash
  make harness
  ```
  Visit http://127.0.0.1:5001/start

## Daily Flow (analysts / power users)
- Use `3in1.py` for a full pipeline (download → extract → analyze → chart):
  ```bash
  python 3in1.py
  ```
- Or open dashboards on already extracted CSVs:
  ```bash
  python dashboard.py
  python dashboard2.py
  python MeetLiveDashboard.py
  ```

## Playbooks

### A) Export via Selenium (`3in1.py`)
- Prereqs: Chrome installed; `.env` with `WP_USERNAME`, `WP_PASSWORD`
- Steps run by `3in1.py`:
  1. Log in to WP Admin (Koko Analytics)
  2. Trigger export download to `DOWNLOAD_DIR` (default `~/Downloads`)
  3. Extract to `EXTRACT_DIR` (default `~/Desktop/analytics_project/extracted`)
  4. Analyze and write chart to `OUTPUT_IMAGE`
- Edit defaults inside `3in1.py` if needed.

### B) Export via REST (`koko_export/export_analytics.py`)
- Prereqs: `.env` with `SITE_URL`, `USERNAME`, `APP_PASS`
- Run:
  ```bash
  python koko_export/export_analytics.py
  ```
- Output: JSON/CSV (as implemented); adapt to your workflow.

### C) Analysis pipeline
- Core function: `analyze_and_visualize(csv_path, output_image)` in `3in1.py`
- Input: `event-click-tracker*.csv`
- Logic: group by `Value` (or fallback `Unnamed: 0`) and sum `Total`
- Output: bar chart PNG at `OUTPUT_IMAGE`

### D) Dashboards (Tkinter)
- `dashboard.py`, `dashboard2.py`, `MeetLiveDashboard.py`
- Load CSVs from `EXTRACT_DIR`
- Use GUI to slice data and visualize trends

### E) Email Reporting
- Function: `send_email(...)` in `3in1.py`
- SMTP: `smtp.gmail.com:587` by default
- Env: `SMTP_USER`, `SMTP_PASSWORD`, `RECIPIENT_EMAIL`
- Enable by uncommenting call in `main()`

### F) Local Test Harness (Flask)
- Start:
  ```bash
  make harness
  ```
- Flow:
  1. Open http://127.0.0.1:5001/start
  2. Fill email + name on the Invite page
  3. Get a generated Landing page with your info
- API endpoints:
  - `POST /token` → create token (JSON)
  - `GET /invite/<token>` → invite page (Jinja)
  - `POST /invite/<token>` → submit form → landing (Jinja)
  - `POST /export` → serves a small Koko-like ZIP

### G) Web UI Migration (Jinja)
- Templates live under `test_harness/templates/`:
  - `base.html`, `invite.html`, `landing.html`
- Static assets under `test_harness/static/`
- Harness app: `test_harness/app.py` renders templates and simulates flow
- Add new pages by creating a template and a route that calls `render_template(...)`

### H) FIDO2: Factory provisioning (Linux)
- CLI (standalone repo): clone and run `NADOO-Key`
  ```bash
  git clone https://github.com/NADOOIT/NADOO-Key.git
  cd NADOO-Key
  sudo ./bin/nadoo-key factory
  ```
- Defaults: touch-only login (no fingerprint/PIN), `max_devices=1` for fast detection
- Env toggles:
  - `FACTORY_COUNT=N` number of keys to process
  - `FACTORY_RESET=0|1` reset FIDO2 app before provisioning
  - `FINGERPRINTS=N` enroll N fingerprints on Bio keys
  - `REQUIRE_UV_LOGIN=0|1` require fingerprint/PIN at login (default 0)
  - `REQUIRE_UV_SUDO=0|1` require fingerprint/PIN for sudo (default 0)
  - `SERVICE_URL`, `SERVICE_TOKEN`, `USER_HINT` for external integration via `scripts/integrations/service_register.sh`
  - `OUTPUT_CSV` path for factory log CSV
- See README: https://github.com/NADOOIT/NADOO-Key

## Quality & Safety
- One command:
  ```bash
  make
  ```
- Coverage report:
  ```bash
  make coverage
  ```
- Coverage suggestions/stubs:
  ```bash
  make coverage:suggest
  make coverage:stubs
  ```
- Data-safety hints:
  ```bash
  make safety
  ```
- Security checks (optional):
  ```bash
  make security:bandit
  make security:audit
  ```

## Configuration
- `.env` (see `.env.example`):
  - Selenium export: `WP_USERNAME`, `WP_PASSWORD`
  - SMTP: `SMTP_USER`, `SMTP_PASSWORD`, `RECIPIENT_EMAIL`
  - REST export: `SITE_URL`, `USERNAME`, `APP_PASS`
  - Optional planned: `WP_BASE_URL`, `WP_LOGIN_URL`, `SMTP_HOST`, `SMTP_PORT`, `BASE_EXTRACT_DIR`

## Maintenance
When behavior changes, update:
- `docs/start_here.md` (onboarding steps)
- `docs/work_plan.md` (this plan)
- `.env.example` (new/changed env vars)
- `Makefile` (add/remove workflows)
- Tests under `tests/` to match new behavior

## FIDO2 Rollout Work Plan

This section outlines a concrete, repeatable plan to deliver a one‑day FIDO2 rollout (up to 500 users) and smaller pilots. It complements the technical notes under "H) FIDO2: Factory provisioning (Linux)" above.

### Scope & Objectives
- __Scope__: Provision FIDO2 security keys; configure Linux login + sudo via `pam_u2f`; default touch‑only login; fingerprint optional.
- __Outcomes__:
  - Users can unlock the GNOME lock screen and run `sudo` with key touch only (no password).
  - Factory provisioning log (CSV) and optional per‑key service registration completed.
  - Handouts delivered to stakeholders (EN/DE).

### Roles & Responsibilities
- __Executive sponsor__: approve scope, timing, and policy (touch‑only vs fingerprint).
- __IT lead__: plan stations/waves, prepare CSV template, coordinate comms, success criteria.
- __Station leads (×N)__: run `nadoo-key` provisioning per user, verify login/sudo, record CSV.
- __Runners__: guide users to stations, triage hardware/hub swaps.
- __Helpdesk__: follow SOP, handle backup/replacement keys.

### Milestones & Timeline
- __T‑14__ Confirm policy, scope (pilot or 1‑day up to 500), hardware quantity (recommend 2 keys/user), venue/hubs.
- __T‑7__ Prepare comms (handouts, FAQ), CSV template, dry‑run lab; confirm `SERVICE_URL` (optional integration).
- __T‑3__ Dry‑run full flow with 3–5 devices; validate GNOME lock screen + sudo on target image.
- __T‑1__ Set up stations, label batches, print signage/QR to docs; pre‑stage `nadoo-key`.
- __Day 0 (event)__
  - 09:00 Kickoff & policy (15m)
  - 09:15 Pilot validation (10 users) → Go/No‑Go
  - 09:45 Wave 1 (125)
  - 11:00 Wave 2 (125)
  - 13:00 Wave 3 (125)
  - 14:15 Wave 4 (125)
  - 16:00 Final verification, reports, handoff
- __T+1__ Aftercare: CSV/report delivery, backup/replacement SOP, feedback.
- __T+7__ Retrospective, finalize documentation, agree next steps.

### Deliverables
- `provisioned.csv` with username, serial, timestamps, status.
- PAM mapping installed and validated for each user: `~/.config/Yubico/u2f_keys` or `/etc/u2f_keys` with correct perms and `openasuser` where required.
- GNOME greeter/lock screen hot‑plug works (`max_devices=1`, wait helper/udev keypress shim installed).
- Stakeholder handouts shared (end‑user, manager, helpdesk; EN/DE).

### Phased Tasks
1) __Preparation__
   - Hardware: keys, hubs, spare cables; recommend 2 keys/user.
   - Workstations: Linux admin access, internet, pre‑installed deps per NADOO-Key README (https://github.com/NADOOIT/NADOO-Key).
   - Configure optional integration: `SERVICE_URL`, `SERVICE_TOKEN`.
2) __Pilot (10 users)__
   - Provision using `sudo ./bin/nadoo-key provision` or register-only via `sudo ./bin/nadoo-key register`.
   - Verify GNOME lock screen + `sudo` touch‑only; capture issues.
3) __Factory (waves)__
   - Run batch with CSV logging:
      ```bash
      git clone https://github.com/NADOOIT/NADOO-Key.git
      cd NADOO-Key
      FACTORY_COUNT=500 \
      REQUIRE_UV_LOGIN=0 REQUIRE_UV_SUDO=0 \
      OUTPUT_CSV=provisioned.csv \
      sudo ./bin/nadoo-key factory
      ```
   - Options: `FACTORY_RESET=1` (wipe first), `FINGERPRINTS=N` (enroll N on Bio), `SERVICE_URL=...`.
4) __Verification & Handoff__
   - Spot‑check login/sudo on sample users per wave.
   - Deliver CSV/report, confirm backup key issuance policy and SOP.

### Technical Notes (defaults)
- New keys: PIN `0000` when initialized as NEW (change later per policy).
- Login defaults: touch‑only; set `REQUIRE_UV_LOGIN=1` / `REQUIRE_UV_SUDO=1` to require fingerprint/PIN.
- GNOME lock screen: ensure mapping path, permissions, `openasuser`, device present; `max_devices=1` for hot‑plug; helper script simulates Enter on plug‑in.

### Risks & Mitigations
- __Fingerprint lockout / red blinking__: default to touch‑only; clear with PIN if needed.
- __Wrong mapping path/permissions__: auto‑create `~/.config/Yubico/u2f_keys` or `/etc/u2f_keys`; set perms; use `openasuser`.
- __Device not present / hub issues__: keep spare hubs/cables; test each station.
- __API downtime (integration)__: queue events locally and retry.

### Acceptance Criteria
- Users can unlock GNOME lock screen and run `sudo` with a single touch (default policy).
- Factory CSV complete; any failed entries triaged or queued for retry.
- PAM configuration validated on sample machines; hot‑plug works at greeter.
- Stakeholder handouts delivered; helpdesk prepared with SOP.

### References & Links
- Read‑first overview: `docs/handouts/read_first_fido2_rollout_guide.md`
- Event runbook (1‑day / 500): `docs/marketing/social_kit/event_runbook_1day_500.md`
- Social/marketing kit: `docs/marketing/social_kit/`
- CLI reference: https://github.com/NADOOIT/NADOO-Key
- Developer onboarding: `docs/start_here.md`
