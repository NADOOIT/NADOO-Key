# FIDO2 für junge Berufstätige

Zielgruppe: ca. 20–35 Jahre (Berufseinstieg, Early‑Career)

## Was ist das?
- Ein Sicherheitsschlüssel, der Passwörter durch eine sichere Berührung ersetzt.
- Funktioniert in Unternehmens‑Logins, DevOps‑Tools und privaten Konten.

## Warum nutzen?
- Phishing‑resistent: verhindert Credential‑Theft und MFA‑Müdigkeit.
- Schnell: Tippen statt Codes, kein Copy‑Paste.
- Professioneller Standard: bei Tech, Banken, Behörden etabliert.

## Technischer Hintergrund (einfach)
- Der Schlüssel hält pro Dienst/Webseite eigene Schlüsselpaare (Origin‑Binding).
- Beim Login sendet der Dienst eine Challenge; der Schlüssel signiert sie.
- Private Schlüssel verlassen das Gerät nicht.

## Spaß & Komfort
- Weniger Unterbrechungen, moderne UX: antippen und weiterarbeiten.
- Ein Schlüssel für mehrere Rechner.

## Spart Zeit
- Weniger Sperren/Resets.
- Schnellere Admin‑Freigaben (sudo) unter Linux.
- Massen‑Provisionierung bei Onboarding‑Tagen.

## Start (Linux)
```bash
sudo ./bin/nadoo-key provision
```
Defaults: PIN 0000 bei neuen Schlüsseln, Touch‑only‑Login; Fingerprint optional per Policy.

## Tipps
- Backup‑Schlüssel anlegen und sicher aufbewahren.
- Browser‑Passkeys mit demselben Sicherheitsschlüssel nutzen.

## FAQs
- Fingerprint erzwingen? Ja — `REQUIRE_UV_LOGIN/REQUIRE_UV_SUDO` setzen.
- Privat nutzen? Ja, Schlüssel dort registrieren, wo Sie ihn brauchen.
