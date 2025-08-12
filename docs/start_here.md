# Start Here — NADOO-Key CLI Quick Start

Audience: Developers, IT engineers

## Requirements
- Linux workstation with sudo
- USB FIDO2 security key (e.g., YubiKey Bio)
- Internet access for package install during provisioning

## TL;DR
- New keys default PIN: 0000
- Login defaults: touch-only (no fingerprint/PIN prompts); fingerprint optional
- Supports Linux sudo and login (incl. GNOME lock screen)

## Basic usage
```bash
# Guided provisioning for the current user
sudo ./bin/nadoo-key provision

# Register the current key only (no full provisioning)
sudo ./bin/nadoo-key register
```

## Factory / batch provisioning
```bash
# Provision N keys in sequence with optional CSV log
FACTORY_COUNT=50 \
OUTPUT_CSV=provisioned.csv \
sudo ./bin/nadoo-key factory
```

### Useful options (env vars)
- REQUIRE_UV_LOGIN=0|1  – require biometric/PIN for login (default 0)
- REQUIRE_UV_SUDO=0|1   – require biometric/PIN for sudo (default 0)
- FINGERPRINTS=N        – enroll up to N fingerprints for Bio keys (interactive by default)
- FACTORY_RESET=1       – wipe keys before (re)issuing in factory mode
- SERVICE_URL=...       – optional per-key registration webhook/API during factory mode
- OUTPUT_CSV=path.csv   – write batch results to CSV

## Notes
- Defaults are optimized for smooth rollouts: touch-only login, fingerprint optional, no lockouts.
- Provisioning installs required packages and configures PAM U2F for sudo and login.
- Mapping file is created automatically (per-user or system-wide as needed); no manual edits.

## Auto‑Unlock (niedrige Hürde zum Entsperren)
- Beim Provisionieren/Registrieren wird standardmäßig ein Benutzer‑Dienst installiert, der nach der Anmeldung automatisch läuft.
- Verhalten: Stecken Sie einen (ggf. gesperrten) FIDO2‑Schlüssel ein → kurzer Hinweisdialog → PIN eingeben (Standard 0000) → biometrische Sperre wird aufgehoben. Es werden keine Anmeldedaten gelöscht.
- Deaktivieren: vor dem Befehl `AUTO_UNLOCK=0` setzen, z. B. `AUTO_UNLOCK=0 sudo ./bin/nadoo-key provision`.
- Manuelle Steuerung:
  ```bash
  # Installieren/aktivieren (Benutzerdienst)
  ./tools/auto_unlock/install.sh install

  # Deaktivieren/entfernen
  ./tools/auto_unlock/install.sh uninstall
  ```
Hinweis: Erfordert `zenity`, `yubikey-manager` (ykman) und `fido2-tools`. Der Installer versucht die Pakete automatisch zu installieren.

## Troubleshooting
 - Helpdesk SOP (EN): [./handouts/fido2_helpdesk_sop.md](./handouts/fido2_helpdesk_sop.md)
 - Helpdesk SOP (DE): [./handouts/fido2_helpdesk_sop_de.md](./handouts/fido2_helpdesk_sop_de.md)

## Contact
- Support: Christoph Backhaus

## Importierte Unterlagen
- Übersicht: [Imported Docs Index](docs/_import/INDEX.md)
