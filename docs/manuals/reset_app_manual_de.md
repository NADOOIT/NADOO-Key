# NADOO‑Key: FIDO2‑Zurücksetzen (Desktop‑App)

Diese kleine App hilft dabei, den FIDO2‑Bereich eines Sicherheitsschlüssels (z. B. YubiKey Bio) zurückzusetzen, ohne Terminal‑Befehle.

Achtung: Das Zurücksetzen löscht alle FIDO/WebAuthn‑Zugänge auf dem Schlüssel.

## Installation
- Voraussetzungen: Linux, sudo‑Rechte, Internet (für Pakete), USB‑Port
- Installieren:
  ```bash
  sudo bash tools/reset/install_reset_desktop.sh install
  ```
- Danach finden Sie die App im Menü: „NADOO‑Key: FIDO2 zurücksetzen“

### Automatisches Entsperren beim Einstecken
- Im Rahmen der Standard‑Einrichtung installiert NADOO‑Key einen Benutzerdienst, der nach der Anmeldung automatisch läuft.
- Stecken Sie einen (ggf. gesperrten, rotes Blinken) FIDO2‑Schlüssel ein, erscheint ein Dialog zur PIN‑Eingabe (Standard 0000). Die biometrische Sperre wird ohne Datenverlust aufgehoben.
- Deaktivieren/Entfernen (optional):
  ```bash
  ./tools/auto_unlock/install.sh uninstall
  ```

### Nicht‑destruktive Wiederherstellung (ohne Datenverlust)
- Zusätzlich wird die App „NADOO‑Key: FIDO2 wiederherstellen (ohne Datenverlust)“ installiert.
- Diese hebt bei Bio‑Schlüsseln die Fingerabdruck‑Sperre (rotes Blinken) durch eine PIN‑Prüfung auf – ohne gespeicherte FIDO/WebAuthn‑Zugänge zu löschen.
- Alternativ können Sie im Terminal direkt ausführen:
  ```bash
  ykman fido access verify-pin
  ```
  (Standard‑PIN in unserer Einrichtung: 0000)

## Nutzung
1) App starten (Menü öffnen, nach „NADOO‑Key“ suchen).
2) Sicherheitsschlüssel einstecken.
3) Admin‑Passwort eingeben (sudo), falls angefordert.
4) Warnhinweis lesen, mit „OK“ bestätigen.
5) Anweisungen auf dem Bildschirm folgen (ggf. Key neu einstecken).
6) Optional: PIN auf 0000 setzen lassen.
7) Fertig. Anschließend Schlüssel mit `NADOO‑Key` neu provisionieren (Login/Sudo).

## Fehlerbehebung
- „Kein FIDO2‑Gerät erkannt“: Key einstecken, ggf. anderen USB‑Port nutzen, 5–10 Sekunden warten.
- „ykman nicht gefunden“: Paket installieren (Ubuntu/Debian: `sudo apt install yubikey-manager`). Der Installer versucht das automatisch.
- „Reset fehlgeschlagen“: Key kurz abziehen/neu einstecken und erneut versuchen. Bei Bio‑Keys ggf. Fingerabdrucksperre per PIN lösen (siehe Wiederherstellung oben).

## Deinstallation
```bash
sudo bash tools/reset/install_reset_desktop.sh uninstall
```

## Support
Bei Fragen: Christoph Backhaus — https://nadooit.de
