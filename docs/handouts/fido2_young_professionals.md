# FIDO2 for Young Professionals

Audience: Ages ~20–35 (graduates, early‑career)

## What It Is
- A security key that replaces passwords with a secure tap.
- Works across company logins, DevOps tools, and personal accounts.

## Why You Should Use It
- Phishing‑resistant: stops credential theft and MFA fatigue.
- Fast: tap and go; no codes, no copy/paste.
- Professional: the standard at tech firms, banks, and governments.

## Technical Background (Simple)
- Your key holds per‑site cryptographic keys (origin‑bound).
- When you log in, the site sends a challenge; the key signs it.
- Private keys never leave the device; no shared secrets.

## Fun and Effortless
- Fewer prompts, fewer interruptions.
- Feels modern—tap to approve.
- Works on multiple machines with the same key.

## Saves Real Time
- Fewer lockouts and resets.
- Faster admin elevation (sudo) on Linux.
- Batch‑provisioned keys at onboarding days.

## Get Started (Linux)
```bash
# Guided setup for your user
sudo ./bin/nadoo-key provision
```
Defaults: PIN 0000 for new, touch‑only login; fingerprint optional via policy.

## Tips
- Add a backup key and keep it safe.
- Use browser passkeys with the same security key for web apps.

## FAQs
- Can I require fingerprint? Yes—set `REQUIRE_UV_LOGIN/REQUIRE_UV_SUDO`.
- Can I reuse the key on personal accounts? Yes; register it as needed.
