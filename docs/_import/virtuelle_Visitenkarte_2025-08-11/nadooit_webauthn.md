# NADOOIT WebAuthn: Passwordless with your Security Key

This guide shows how to use your FIDO2 Security Key to register and sign in to the NADOOIT website/app with no passwords and no personal data. Your key is your membership card (Genossenschaftsausweis).

## What you need
- A FIDO2/WebAuthn Security Key (e.g., YubiKey, SoloKey, etc.).
- A supported browser: Chrome, Edge, Safari, Firefox (recent versions).
- Plug your key into USB (or pair via NFC/BLE if supported by your device).

Tip (Linux only): If you also want to use the key for local sudo/login or a local encrypted vault, see `fido2/README.md` and `fido2/VAULT.md`.

## Register (first time)
Registration starts when you are invited to NADOOIT.

1. Open your invitation (link, QR code, or other channel).
2. Follow the prompts in your browser/app.
3. When asked, use your security key.
4. Touch the key when it blinks. If your key uses a PIN/fingerprint, follow the prompt.
5. Done. No name or email required; the credential lives on your key and is bound to NADOOIT.

## Sign in (later)
1. Go to the NADOOIT website/app.
2. Choose “Sign in with Security Key”.
3. Touch the key (enter PIN or use fingerprint if asked).
4. You are in.

## Privacy & Security
- No personal data is needed for registration. The credential is unique to NADOOIT and cannot be phished for other sites.
- The key proves “it’s you” using public‑key cryptography. NADOOIT never learns your PIN/fingerprint.
- You can register multiple keys for backup.

## Managing your credentials
- You can add another key by repeating “Register with Security Key”.
- To remove a key, use the “Manage Security Keys” section in NADOOIT (if available) or contact support.
- Browsers and OSes may also show your registered credentials in their security settings.

## Troubleshooting
- Key not detected: try another USB port; ensure WebAuthn is allowed in your browser; try a normal (non‑incognito) window; update your browser.
- PIN/fingerprint prompts: these come from your key. If you forget your PIN, reset the key (this wipes credentials) and re‑register.
- Multiple devices: you can register the same key on multiple devices; the credential is per‑site, not per‑device.

## Next steps
- Linux local login/sudo with your key: `sudo bash fido2/setup_linux.sh` (see `fido2/README.md`).
- Local encrypted vault unlocked by your key: see `fido2/VAULT.md` and `fido2/vault_linux.sh`.

## Developers: Integrations and tooling
- Backend services and bots (Telegram/WhatsApp): https://github.com/NADOOIT/NADOO-IT
- Development toolkit and code generation: https://github.com/NADOOIT/NADOO-Launchpad
- See `docs/integrations.md` for recommended folder layout and clone/submodule instructions.
