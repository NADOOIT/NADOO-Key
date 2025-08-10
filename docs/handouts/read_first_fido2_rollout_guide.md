# Read First – FIDO2 Rollout Guide (One Document)

Purpose: One concise document to brief a team and point to exactly where to dive deeper.
Audience: Executives, IT/Security leads, managers, helpdesk, and project team.

---

## TL;DR
- We deploy phishing‑resistant FIDO2 keys with 1‑touch login.
- Linux login + sudo today; web apps on all platforms; macOS sudo supported.
- Defaults: PIN 0000 for new keys; touch‑only (no fingerprint) to avoid lockouts; fingerprint optional.
- Mass provisioning: up to 500 users in one day using `factory` mode with CSV + optional API hook.
- Handouts exist for each audience; use the links below to dive deeper.

---

## What to do now
- Decide policy: touch‑only vs fingerprint for login/sudo.
- Choose date and scope (pilot 5–10 users; or 1‑day rollout up to 500).
- Ensure hardware (2 keys/user recommended) and a booking link.

---

## Quick technical start
- Guided provisioning (single user):
  ```bash
  cd nadoo-key
  sudo ./bin/nadoo-key provision
  # or just register the current key
  sudo ./bin/nadoo-key register
  ```
- Factory provisioning (batch):
  ```bash
  FACTORY_COUNT=500 \
  REQUIRE_UV_LOGIN=0 REQUIRE_UV_SUDO=0 \
  OUTPUT_CSV=provisioned.csv \
  sudo ./bin/nadoo-key factory
  ```
  Options: `FACTORY_RESET=1` (wipe before issue), `FINGERPRINTS=N`, `SERVICE_URL=https://...` (per‑key registration).

Key defaults & notes:
- New keys are initialized with PIN = 0000 (change later per policy).
- Touch‑only login by default; set `REQUIRE_UV_LOGIN=1` / `REQUIRE_UV_SUDO=1` to require fingerprint/PIN.

---

## One‑day rollout (up to 500)
- Read the runbook: [event_runbook_1day_500.md](../marketing/social_kit/event_runbook_1day_500.md)
- Stations, timeline, CSV logging, and roles are defined. Use handouts below for comms.

---

## Deep dives (read as needed)
- Business value and ROI
  - EN: [fido2_customer_handout.md](./fido2_customer_handout.md)
  - DE: [fido2_kundenhandout.md](./fido2_kundenhandout.md)
  - Pricing & packages: [pricing.md](../product/pricing.md)
  - Product plan: [product_plan.md](../product/product_plan.md)
- Stakeholder handouts (share with teams)
  - End‑user: EN [fido2_end_user_quick_start.md](./fido2_end_user_quick_start.md), DE [fido2_end_user_kurzanleitung.md](./fido2_end_user_kurzanleitung.md)
  - Managers: EN [fido2_manager_brief.md](./fido2_manager_brief.md), DE [fido2_manager_kurzuebersicht.md](./fido2_manager_kurzuebersicht.md)
  - Helpdesk SOP: EN [fido2_helpdesk_sop.md](./fido2_helpdesk_sop.md), DE [fido2_helpdesk_sop_de.md](./fido2_helpdesk_sop_de.md)
  - Older employees guide: EN [fido2_older_adults_guide.md](./fido2_older_adults_guide.md), DE [fido2_aeltere_benutzer_leitfaden.md](./fido2_aeltere_benutzer_leitfaden.md)
- Marketing & launch (optional)
  - Social kit (EN/DE): [social kit](../marketing/social_kit/README.md)
  - Landing page copy: EN [landing_page_copy_en.md](../marketing/social_kit/landing_page_copy_en.md), DE [landing_page_copy_de.md](../marketing/social_kit/landing_page_copy_de.md)
- Engineering details
  - CLI usage: [README.md](../../README.md)
  - Developer setup: [start_here.md](../start_here.md)

---

## Troubleshooting snapshot
- Red blinking Bio key: unlock with PIN once; retry. Keep default touch‑only to avoid lockouts.
- GNOME login: ensure mapping path exists (`~/.config/Yubico/u2f_keys` or `/etc/u2f_keys`), correct permissions, `openasuser`, and device present.
- Greeter hot‑plug: helper and `max_devices=1` already integrated.

---

## Roles & responsibilities (minimal)
- Executive sponsor: approve budget/timeline.
- IT lead: policy, scheduling, coordination, success criteria.
- Station leads (rollout day): provisioning per station, CSV logging.
- Helpdesk: follow SOP, handle replacements/backups.

---

## Next steps
- Pick policy and date. If doing 1‑day rollout, follow the runbook and use the handouts.
- For a quote, see [pricing.md](../product/pricing.md) or use the proposal template: [proposal_template.md](../product/proposal_template.md).

---

## Contact
- Christoph Backhaus (IT/Security) – Support and delivery
