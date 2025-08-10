# FIDO2-Sicherheitsschlüssel für Unternehmen

Zielgruppe: Geschäftsführung, IT‑Leitung, Security‑Verantwortliche

Ziel: Was ist FIDO2, warum ist es wichtig, wie führt man es ein, wer nutzt es, welche Risiken bestehen ohne FIDO2 und wie rechnet sich das (Kosten/Nutzen und Zeitersparnis).

---

## Zusammenfassung (Executive Summary)
- Starker, phishing‑resistenter Login: Passwörter werden durch eine einfache Berührung am Sicherheitsschlüssel ersetzt.
- Schnellere Einführung und weniger Support‑Tickets dank One‑Button‑Setup und Factory‑/Massen‑Provisionierung.
- Bewährt bei Big Tech, Banken und Behörden; entspricht aktuellen Empfehlungen (NIST, CISA, ENISA).
- Überschaubare, planbare Kosten im Verhältnis zu deutlich niedrigeren Risiken und geringeren Betriebskosten.

---

## Was ist FIDO2?
- FIDO2/WebAuthn‑Sicherheitsschlüssel (z. B. YubiKey Bio) sind kleine Hardware‑Tokens für sichere Anmeldungen.
- Kryptografische Geheimnisse bleiben im Gerät (tamper‑resistent); es gibt kein auslesbares „Master‑Passwort“.
- Keine Phishing‑Angriffsfläche wie bei Passwörtern oder Einmalcodes; jede Website/Anwendung nutzt ein eigenes Schlüsselpaar (Origin‑Binding).

---

## Warum FIDO2 einführen?
- Phishing‑Resistenz: verhindert Credential‑Theft und MFA‑Fatigue‑Angriffe.
- Weniger Sicherheitsvorfälle: keine Passwort‑Wiederverwendung, keine schwachen Passwörter.
- Schnellere Logins: Berührung statt OTP/Copy‑Paste; typischerweise <2 Sekunden.
- Weniger Supportaufwand: drastisch weniger Passwort‑Resets und Sperren.
- Breite Unterstützung: funktioniert im Web (Passkeys) und auf Linux auch für Geräte‑Login und sudo; macOS/Windows sind heute für WebAuthn/Passkeys erstklassig, OS‑Login je nach Plattform.

---

## Wer nutzt FIDO2 bereits?
- Technologie: Google, Microsoft, Apple, GitHub, Okta.
- Finanzbranche: Große Banken/Payment‑Anbieter.
- Öffentlicher Sektor: Behörden im Zuge von Zero‑Trust‑Programmen.
- Mittelstand: Reduktion von Supportkosten und Cyber‑Risiken.

---

## Risiken ohne FIDO2
- Höheres Risiko für Phishing/Credential‑Stuffing → Account‑Übernahmen, Datenabfluss.
- Einfallstor für Ransomware über kompromittierte Zugangsdaten.
- Laufende operative Kosten: Passwort‑Resets, OTP‑Probleme, Incident Response.
- Druck durch Compliance/Cyber‑Versicherungen: phishing‑resistente MFA wird Erwartungswert.

---

## So funktioniert es in Ihrer Organisation
- Jede Mitarbeiterin/jeder Mitarbeiter erhält einen FIDO2‑Schlüssel (optional je ein Backup‑Schlüssel pro Person).
- Unser Tooling richtet Linux‑Logins (inkl. GNOME‑Sperrbildschirm) und sudo ein – standardmäßig „Touch‑only“; Fingerabdruck optional aktivierbar.
- Zuordnung Schlüssel↔Benutzer erfolgt automatisch; keine manuelle Dateipflege nötig.
- Optionaler Integrations‑Hook registriert jeden Schlüssel während der Massen‑Provisionierung in externen IT‑Systemen.

---

## Einführungsvarianten
- Geführtes One‑Button‑Provisioning:
  - `sudo ./bin/nadoo-key provision`
  - Installiert Pakete, erkennt den Schlüssel, initialisiert neue Schlüssel mit PIN = 0000, optional Fingerprint‑Enrollment, konfiguriert PAM für sudo und Login.
- Factory‑/Massen‑Provisionierung:
  - `FACTORY_COUNT=100 sudo ./bin/nadoo-key factory`
  - Optionen: `FACTORY_RESET=1` (vor Ausgabe löschen), `FINGERPRINTS=N`, `REQUIRE_UV_LOGIN=0|1`, `REQUIRE_UV_SUDO=0|1`, `SERVICE_URL=...` für externe Registrierung, `OUTPUT_CSV` für Logging.
- Nutzerfreundliche Defaults:
  - Touch‑only‑Login (keine Fingerabdruck/PIN‑Abfrage) verhindert Bio‑Sperren; Fingerprint optional.
  - Schnelle Erkennung am Anmeldebildschirm (PAM‑Wait‑Helper, `max_devices=1`).

---

## Endanwender‑Erlebnis
- Schlüssel einstecken. Am Sperrbildschirm/Greeter: Schlüssel berühren → angemeldet.
- Für sudo/Admin‑Prompts: Schlüssel berühren. Fingerabdruck kann per Policy gefordert werden.
- Bei Bio‑Schlüsseln: Nach zu vielen Fehlversuchen lässt sich der Fingerprint‑Zähler per PIN entsperren; danach normal weiter.

---

## IT‑Betrieb: Zeit‑ und Kostenvorteile
- Weniger Tickets:
  - Passwort‑Resets kosten intern oft 15–70€ pro Vorgang; FIDO2 reduziert diese drastisch.
  - Keine OTP‑Drift/Timeouts, weniger App‑Enrollments pro Gerät.
- Schnellere Onboarding‑Wellen:
  - Factory‑Modus provisioniert Dutzende/Hunderte Schlüssel in einer Session; CSV‑Protokoll, optional API‑Registrierung.
- Vereinfachte Fehlersuche:
  - Automatisierte PAM‑Konfiguration, Mapping/Permissions‑Checks und Device‑Wait‑Helper minimieren manuelle Schritte.

---

## Kosten & Wirtschaftlichkeit (ROI)
- Hardware pro Nutzer: ca. 50–90€ je Schlüssel (modellabhängig). Viele Organisationen geben 2 Schlüssel/Person aus.
- Einmaliger Setup‑Aufwand: Minuten im geführten Modus; Sekunden pro Schlüssel im Factory‑Modus.
- Laufende Kosten: minimal. Schlüssel halten i. d. R. mehrere Jahre; keine Lizenzkosten pro Authentifizierung.
- Beispielrechnung (Illustration):
  - Annahmen: 100 Nutzer, 2 Resets/Nutzer/Jahr zu 30€ internen Kosten; zwei Schlüssel pro Nutzer à 70€.
  - Ausgangslage Resets/Jahr: 100 × 2 × 30€ = 6.000€.
  - Hardware: 100 × 2 × 70€ = 14.000€ (einmalig).
  - Wenn FIDO2 Resets um 80% senkt: 4.800€ Einsparung/Jahr; Break‑even ≈ 3 Jahre (ohne Sicherheitsvorfälle eingerechnet).
  - Mit vermiedenen Incidents (ein einziger Vorfall kann die Hardwarekosten übersteigen) amortisiert es sich meist deutlich schneller.
- Zusätzliche „weiche“ Effekte: Produktivität, weniger Login‑Verzögerungen, geringere Trainings/Phishing‑Simulationslast.

---

## Sicherheit & Datenschutz
- Private Schlüssel verlassen das Gerät nicht; Signaturen erfolgen auf dem Token.
- Origin‑Binding verhindert Wiederverwendung/Replay von Anmeldedaten.
- Unsere Einrichtung speichert nur lokale PAM‑Mappings; keine personenbezogenen Daten im Tool.
- Policies können Fingerabdruck/PIN erzwingen; Default vermeidet Bio‑Sperren.

---

## Kompatibilität
- Linux: Geräte‑Login (GDM/Sperrbildschirm), sudo (`pam_u2f`) und Web‑Apps.
- macOS/Windows: erstklassig für Web‑Apps (Passkeys/WebAuthn). OS‑Login per Sicherheitsschlüssel je nach Plattform; sudo via `pam_u2f` auf macOS möglich. Wir dokumentieren den aktuellen Stand.

---

## Umsetzungsschritte (Checklist)
- Hardware‑Beschaffung: Modellwahl, Backup‑Schlüssel‑Policy.
- Policy: Fingerabdruck/PIN‑Anforderungen festlegen (`REQUIRE_UV_LOGIN`, `REQUIRE_UV_SUDO`).
- Pilot: kleine Gruppe testen; externe Registrierung (`SERVICE_URL`) bei Bedarf anbinden.
- Rollout: Factory‑Modus für Massen‑Provisionierung; Verteilung der Schlüssel; Kommunikation an Nutzer.
- Support: kurzes SOP für das Entsperren von Bio‑Schlüsseln per PIN bei Fingerprint‑Lockout.

---

## Preise & Leistungen (Beispiel)
- Starter: bis 25 Nutzer — feste Einrichtungsgebühr + Hardware zum EK.
- Growth: 26–250 Nutzer — Mengenrabatte bei Provisionierung, optionale Integration.
- Enterprise: 250+ Nutzer — individuelles Onboarding, API‑Integration, Reporting, Schulungen.
- Optional: Managed Provisioning (remote/vor Ort), Stock‑to‑Desk.

---

## FAQs
- Schlüssel verloren? Backup‑Schlüssel ausgeben, Mapping widerrufen, mit Backup weiterarbeiten.
- Internet nötig? Für lokale Logins nicht; Web‑Apps benötigen normale Konnektivität.
- Biometrics nutzbar? Ja. Default ist Touch‑only; UV (Fingerprint/PIN) per Policy aktivierbar.
- Ein Schlüssel auf mehreren Geräten? Ja; Schlüssel kann auf mehreren Systemen registriert werden.

---

## Kontakt
- Support & Vertrieb: Christoph Backhaus
- Integration & Technik: NADOO‑IT / NADOO‑Launchpad Team
