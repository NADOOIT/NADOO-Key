# Partner Enablement One‑Pager
Offer: “Setup in One Day (Up to 500 People)” – FIDO2 Security Keys

Audience: Colleagues, partner teams, solution owners
Goal: Enable you to confidently sell and deliver the 1‑day rollout

---

## Why this offer (for customers)
- Phishing‑resistant by design (no OTP codes to phish)
- One‑touch user experience (plug + touch, fingerprint optional)
- Measurable ROI: fewer password resets, faster onboarding, happier users

## Why this offer (for you)
- Simple to deliver with our tooling and runbook
- Clear scope: up to 500 users in one day
- Ready‑made materials: handouts, webinar script, social posts, LP copy (EN/DE)

---

## What’s included
- CLI & automation: `nadoo-key` with guided and factory provisioning (PIN 0000 for new keys by default; touch‑only login default; fingerprint optional)
- Linux login + sudo via pam_u2f, hot‑plug helper, robust defaults
- Batch/factory mode with CSV logging and optional integration hook (per‑key API)
- Assets: social kit, event runbook, webinar script, Q&A, handouts (EN/DE)
- "Read First" overview for teams: `docs/handouts/read_first_fido2_rollout_guide.md`

---

## How you deliver (summary)
- Pre‑day: confirm hardware (2 keys/user recommended), stations (e.g., 4), CSV template, venue/power, comms
- Day‑of: follow the runbook waves (4×125), verify login/sudo per user, log to CSV, optional service registration
- Aftercare: deliver CSV/report, backups/replacements SOP, follow‑up check

See: `docs/marketing/social_kit/event_runbook_1day_500.md`

---

## Demo script (3 minutes)
1) Lock screen → plug key → touch → unlocked
2) Terminal → `sudo` prompt → touch → elevated
3) Explain defaults: touch‑only; fingerprint optional; PIN 0000 new, changeable by policy

---

## FAQs (objections you’ll hear)
- “We already have MFA.” → Many MFAs are phishable; FIDO2 isn’t. Faster UX.
- “Fingerprint required?” → No. Touch‑only default avoids lockouts. Can enable by policy.
- “macOS/Windows?” → Web apps/passkeys work across platforms; Linux OS login now; macOS sudo supported.
- “Lost keys?” → Issue backup; revoke mapping; user continues.
- “500 in one day?” → Multi‑station factory flow with CSV + pre‑briefed waves.

---

## Packaging & pricing guidance
- Scope: 1‑day onsite/remote for up to 500 users, plus prep and aftercare
- Pricing: fixed fee per event + optional per‑user adders (training, spare keys)
- Hardware: pass‑through or sourced at cost; recommend 2 keys/user
- Upsell: training session, follow‑up support, additional rollout days

(Adjust to your market; keep pricing simple and fixed for speed.)

---

## Next steps for colleagues
- Skim the overview: `docs/handouts/read_first_fido2_rollout_guide.md`
- Review the runbook: `docs/marketing/social_kit/event_runbook_1day_500.md`
- Use social/email kit to book discovery calls: `docs/marketing/social_kit/`
- Rehearse the 3‑minute demo; schedule a pilot or set a 1‑day date

Contacts: Christoph Backhaus (IT/Security) – Support and delivery
