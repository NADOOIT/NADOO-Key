# FIDO2 Security Keys for Business

Audience: Business decision makers, IT leads, security champions

Goal: Explain what this is, why it matters, how to deploy, who else uses it, risks of not adopting, and the business case (costs and savings).

---

## Executive Summary
- Strong, phishing‑resistant login that replaces passwords with a simple touch of a security key.
- Faster onboarding and fewer support tickets using our one‑button setup and factory (batch) provisioning.
- Proven by big tech, banks, and governments; aligned with modern security guidance (NIST, CISA, ENISA).
- Costs are predictable and low compared to the time and risk saved.

---

## What It Is
- FIDO2/WebAuthn security keys are small hardware devices (e.g., YubiKey Bio) used for secure login.
- They store cryptographic secrets in tamper‑resistant hardware; secrets never leave the device.
- No password to phish or reuse; authentication is origin‑bound (per‑site key pairs).

---

## Why You Should Use It
- Phishing resistance: prevents credential theft and MFA fatigue attacks.
- Fewer breaches: eliminates password reuse and weak passwords.
- Faster login: touch‑to‑sign, typically under 2 seconds; no OTP copy/paste.
- Simpler support: drastically fewer password resets and lockout tickets.
- Works online (web apps) and offline (device login, sudo) on Linux; macOS/Windows supported for web apps today, with platform‑specific login options evolving.

---

## Who Else Uses This
- Technology: Google, Microsoft, Apple, GitHub, Okta.
- Finance & fintech: Major banks and payment providers.
- Government & public sector: Agencies adopting phishing‑resistant MFA in line with Zero Trust.
- SMEs: Companies seeking to reduce support load and cyber‑insurance risk.

---

## What Happens If You Don’t Adopt
- Increased phishing/credential‑stuffing risk leading to account takeover and data loss.
- Ransomware exposure via compromised credentials.
- Ongoing costs from password resets, OTP handling, and incident response.
- Compliance and cyber‑insurance pressure as phishing‑resistant MFA becomes a baseline expectation.

---

## How It Works in Your Organization
- Each employee receives a FIDO2 key. Optionally add a backup key per user.
- Our tooling sets up Linux logins (including GNOME lock screen) and sudo with touch‑only by default; fingerprint is optional and can be enabled.
- Mapping of keys to users is automatic; no manual file editing required.
- Optional integration hook lets you register each key with external IT systems during batch provisioning.

---

## Deployment Options
- One‑button provisioning (guided):
  - `sudo ./bin/nadoo-key provision`
  - Installs packages, detects the key, initializes new keys with PIN = 0000, optionally enrolls fingerprints, configures PAM for sudo and login.
- Factory (batch) provisioning for many keys:
  - `FACTORY_COUNT=100 sudo ./bin/nadoo-key factory`
  - Options: `FACTORY_RESET=1` (wipe before issue), `FINGERPRINTS=N`, `REQUIRE_UV_LOGIN=0|1`, `REQUIRE_UV_SUDO=0|1`, `SERVICE_URL=...` for external registration, `OUTPUT_CSV` logging.
- Defaults optimized for smooth experience:
  - Touch‑only login (no fingerprint/PIN prompts) to avoid biometric lockouts; fingerprint optional.
  - Fast detection at the login screen using a wait helper and `max_devices=1`.

---

## End‑User Experience
- Plug the key. On lock screen/greeter: touch the key to log in.
- For sudo or admin prompts: touch the key. Fingerprint can be required if your policy sets it.
- If a Bio key locks out fingerprints (e.g., after too many failed touches), users can unlock via PIN and continue.

---

## IT Operations: Time Savings
- Less ticket volume:
  - Password reset tickets often cost 15–70€ each in time and disruption; FIDO2 keys reduce resets dramatically.
  - No more OTP drift/timeouts or authenticator app enrollments per device.
- Faster onboarding:
  - Factory mode provisions dozens to hundreds of keys in a single session with CSV logging and optional API registration.
- Simplified troubleshooting:
  - Automated PAM configuration, mapping, permissions checks, and device wait helpers reduce manual steps.

---

## Cost and ROI
- Typical hardware cost per user: 50–90€ per key (model dependent). Many orgs issue 2 keys/user.
- One‑time setup effort: minutes per user with guided provisioning; seconds per key in factory mode.
- Ongoing costs: minimal. Keys last years; no recurring license to authenticate.
- Sample ROI calculation (illustrative):
  - Assumptions: 100 users, 2 resets/user/year at 30€ internal cost/reset; two keys per user at 70€ each.
  - Baseline annual reset cost: 100 × 2 × 30€ = 6,000€.
  - Hardware: 100 × 2 × 70€ = 14,000€ (one‑time).
  - If FIDO2 cuts resets by 80%: save 4,800€/year; breakeven in ≈ 3 years excluding breach risk.
  - Factoring avoided incidents (even one prevented compromise can exceed hardware cost), payback is typically much faster.
- Add soft savings: improved productivity, fewer login delays, reduced phishing simulations/training burden.

---

## Security and Privacy
- Keys perform cryptographic operations on‑device; private keys never leave the hardware.
- Origin binding (per‑site keys) prevents credential reuse or replay.
- Our setup stores only local mapping data for PAM; no personal data is collected by the tool.
- Policies can require fingerprint/PIN where necessary; default avoids biometric lockouts.

---

## Compatibility
- Linux: device login (GDM/lock screen), sudo (`pam_u2f`), and web apps.
- macOS/Windows: first‑class for web apps (passkeys/WebAuthn). OS‑level login via security key varies by platform; sudo via `pam_u2f` is supported on macOS. We track and document the latest.

---

## Implementation Checklist
- Hardware procurement: choose key model(s), decide on backup key policy.
- Policy: decide on fingerprint/PIN requirements (`REQUIRE_UV_LOGIN`, `REQUIRE_UV_SUDO`).
- Pilot: small group validation, integrate external registration (`SERVICE_URL`) if needed.
- Rollout: use factory mode for mass provisioning; distribute keys; communicate end‑user steps.
- Support: add a brief SOP for unlocking Bio keys via PIN if fingerprint locks.

---

## Pricing & Engagement (example)
- Starter: up to 25 users — fixed setup fee + hardware at cost.
- Growth: 26–250 users — volume discount on provisioning and optional integration.
- Enterprise: 250+ users — custom onboarding, API integration, reporting, and training.
- We also offer managed provisioning (on‑site/remote) and stock‑to‑desk services.

---

## FAQs
- What if a user loses a key? Issue a backup key; revoke mapping; user continues with backup.
- Do we need internet? Not for local login; web apps need normal connectivity.
- Can we use biometrics? Yes. Default is touch‑only; enable UV when required.
- Can one key work on multiple devices? Yes; register the same key where needed.

---

## Contact
- Support and sales: Christoph Backhaus
- Integration and technical questions: NADOO‑IT / NADOO‑Launchpad team
