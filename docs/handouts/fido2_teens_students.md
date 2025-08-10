# FIDO2 for Teens & Students

Audience: Ages ~13–22 (students, apprentices)

## What It Is
- A small USB security key that replaces passwords with a tap.
- Works for school portals, personal accounts, and coding/dev services.

## Why Use It
- Stop phishing: no code typing, no fake login pages tricking you.
- Fast login: tap the key; no remembering long passwords.
- Use one key on many devices and accounts.

## How It Works (Simple)
- Your key stores secret keys safely.
- Sites and apps ask the key to prove "it’s you"—only for that site.
- Your private data never leaves the key.

## Fun To Use
- Tap to log in—feels instant.
- No more “forgot password” or SMS codes.
- Clip it to your backpack or keyring.

## Saves Time
- No password resets, fewer support emails.
- Move between computers quickly: plug, tap, done.

## Get Started
```bash
# On Linux (guided setup for your user)
sudo ./bin/nadoo-key provision
```
- Default: touch-only login (no fingerprint needed). PIN is 0000 for new keys.
- Add fingerprint later if your device supports it.

## Privacy & Security
- The key signs challenges; your secrets never leave the device.
- You can use a backup key for safety.

## FAQs
- What if I lose it? Use your backup key; add a new one when you can.
- Can I use it at school and at home? Yes—register it where you need it.
- Does it track me? No. It only helps you log in securely.
