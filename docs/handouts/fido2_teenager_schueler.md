# FIDO2 für Teenager & Schüler:innen

Zielgruppe: ca. 13–22 Jahre (Schule, Ausbildung)

## Was ist das?
- Ein kleiner USB‑Sicherheitsschlüssel, der Passwörter mit einer Berührung ersetzt.
- Funktioniert für Schulportale, private Accounts und Coding/Dev‑Dienste.

## Warum benutzen?
- Schutz vor Phishing: keine Codes, keine Fake‑Logins.
- Schnell: Antippen statt merken und tippen.
- Ein Schlüssel für mehrere Geräte und Konten.

## Wie funktioniert’s (einfach erklärt)
- Der Schlüssel speichert geheime Schlüssel sicher.
- Webseiten/Apps fragen den Schlüssel: „Bist du es?“ – nur für diese Seite.
- Private Daten verlassen das Gerät nicht.

## Macht Spaß
- Antippen → eingeloggt.
- Kein „Passwort vergessen“ oder SMS‑Codes.
- Am Schlüsselbund oder Rucksack befestigen.

## Spart Zeit
- Weniger Zurücksetzen, weniger Mails.
- Schnell zwischen PCs wechseln: einstecken, tippen, fertig.

## Loslegen (Linux)
```bash
sudo ./bin/nadoo-key provision
```
- Standard: Touch‑only Login (kein Fingerabdruck nötig). PIN ist 0000 bei neuen Schlüsseln.
- Fingerabdruck kann später hinzugefügt werden (falls unterstützt).

## Datenschutz & Sicherheit
- Der Schlüssel signiert Herausforderungen; Geheimnisse bleiben im Gerät.
- Ein Backup‑Schlüssel ist sinnvoll.

## FAQs
- Verloren? Backup nutzen; neuen Schlüssel registrieren.
- In Schule und Zuhause? Ja – überall registrieren, wo du ihn brauchst.
- Tracking? Nein. Es geht nur ums sichere Anmelden.
