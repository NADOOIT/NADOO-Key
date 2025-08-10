# Helpdesk SOP – FIDO2

Zielgruppe: IT‑Support / Service Desk

## Triage‑Checkliste
- Ist der Schlüssel sichtbar? `lsusb` oder neu einstecken; anderen Port testen.
- Linux‑Login/sudo konfiguriert? pam_u2f in `/etc/pam.d/login`, DM‑Dateien und `/etc/pam.d/sudo` prüfen.
- Mapping‑Datei vorhanden? `~/.config/Yubico/u2f_keys` existiert und ist nicht leer.
- Fingerprint‑Lockout? Nutzer einmal zur PIN‑Eingabe auffordern.

## Häufige Abhilfen
- Mapping neu registrieren: `sudo ./bin/nadoo-key register`
- Nutzer neu provisionieren: `sudo ./bin/nadoo-key provision`
- PAM‑Optionen aktualisieren (Touch‑only vs Fingerprint): `REQUIRE_UV_LOGIN`/`REQUIRE_UV_SUDO` setzen und mit `FORCE=1` erneut ausführen.
- Device‑Regeln: Provisionierung erneut starten (udev reload); Pakete `libfido2`, `pam_u2f` prüfen.

## Schlüssel ersetzen/hinzufügen
1) Backup‑Schlüssel ausgeben.
2) Registrieren: `sudo ./bin/nadoo-key register` (Nutzer berührt den Schlüssel).
3) Altes Mapping bei Bedarf entfernen.

## Factory‑Modus (Massen)
- Befehl: `FACTORY_COUNT=N sudo ./bin/nadoo-key factory`
- Optionen: `FACTORY_RESET=1`, `FINGERPRINTS=N`, `SERVICE_URL=...` (pro Schlüssel API), `OUTPUT_CSV=...`

## Eskalation
- Wenn PAM‑Änderungen nicht greifen, mitgeben:
  - Betroffene PAM‑Dateien, Mapping‑Pfad, Dateirechte, Device‑Logs
- Eskalation an: Christoph Backhaus / Security Engineering
