# Encrypted Vault (Linux) unlocked by your FIDO2 key

Goal: a private folder that’s unreadable when the key isn’t present and instantly usable when you touch the key. Nothing leaves your computer.

This uses a LUKS2 container (a file that holds an encrypted filesystem) and a FIDO2 token for unlock.

## Quick start
```bash
# Create a 2 GiB vault and mount at ~/NADOO_Vault
sudo ./bin/nadoo-key vault create --size 2G --mount ~/NADOO_Vault

# Open (unlock + mount) the vault (touch the key)
sudo ./bin/nadoo-key vault open --mount ~/NADOO_Vault

# Close (unmount + lock) the vault
sudo ./bin/nadoo-key vault close --mount ~/NADOO_Vault

# Status
sudo ./bin/nadoo-key vault status
```

## How it works
- Creates a file (e.g., `~/.local/share/nadoo_vault/vault.luks`) and formats it as LUKS2.
- You set a recovery passphrase (for emergencies).
- Enrolls your FIDO2 key using `systemd-cryptenroll`.
- Opening uses the key (PIN/fingerprint) and a touch; closing removes access.

## Notes
- Requires packages: `cryptsetup`, `systemd` tools (already on most distros).
- The vault is separate from OS login and sudo; it’s your personal secure storage.
- You can change size and mount path. Back up the vault file like any other file.
- If you lose the key: unlock using your recovery passphrase.

## Advanced (optional)
- Auto-open on login: add a user service that runs `nadoo-key vault open` after you log in and your key is present.
- Multiple keys: run `systemd-cryptenroll --fido2-device=auto ~/.local/share/nadoo_vault/vault.luks` with the other key.
