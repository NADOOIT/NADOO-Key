# Partner‑Enablement One‑Pager
Angebot: „In einem Tag eingerichtet (bis 500 Personen)” – FIDO2‑Sicherheitsschlüssel

Zielgruppe: Kolleg:innen, Partner‑Teams, Solution Owner
Ziel: Kolleg:innen befähigen, den 1‑Tages‑Rollout sicher zu verkaufen und zu liefern

---

## Warum dieses Angebot (für Kund:innen)
- Phishing‑resistent by Design (keine OTP‑Codes abfangbar)
- Einfache UX: einstecken + berühren (Fingerprint optional)
- Messbarer ROI: weniger Passwort‑Resets, schnelleres Onboarding, zufriedenere Nutzer

## Warum dieses Angebot (für euch)
- Einfache Lieferung mit unseren Tools und Runbook
- Klarer Umfang: bis zu 500 Personen an einem Tag
- Fertige Materialien: Handouts, Webinar‑Skript, Social Posts, LP‑Texte (DE/EN)

---

## Was enthalten ist
- CLI & Automatisierung: `nadoo-key` mit Guided & Factory Provisioning (PIN 0000 bei neuen Keys; Touch‑only Login Standard; Fingerabdruck optional)
- Linux‑Login + sudo via pam_u2f, Hot‑Plug‑Helfer, robuste Defaults
- Batch/Factory‑Modus mit CSV‑Logging und optionalem Integrations‑Hook (pro Schlüssel API)
- Assets: Social Kit, Event‑Runbook, Webinar‑Skript, Q&A, Handouts (DE/EN)
- „Read First” Überblick für Teams: [read_first_fido2_rollout_guide.md](./read_first_fido2_rollout_guide.md)

---

## So liefert ihr (Kurzfassung)
- Vortag: Hardware klären (Empfehlung: 2 Keys/Nutzer), Stationen planen (z. B. 4), CSV‑Template, Location/Power, Kommunikation
- Rollout‑Tag: Wellen (4×125) gemäß Runbook, Login/sudo je Nutzer verifizieren, CSV pflegen, optional Service‑Registrierung
- Danach: CSV/Report übergeben, Backup/Replacement‑SOP, Follow‑up Termin

Siehe: [event_runbook_1day_500.md](../marketing/social_kit/event_runbook_1day_500.md)

---

## Demo‑Skript (3 Minuten)
1) Sperrbildschirm → Schlüssel einstecken → berühren → entsperrt
2) Terminal → `sudo` Prompt → berühren → Admin
3) Defaults erklären: Touch‑only; Fingerprint optional; PIN 0000 bei neuen Keys, per Policy änderbar

---

## FAQs (typische Einwände)
- „Wir haben schon MFA.“ → Viele MFAs sind phishbar; FIDO2 nicht. Schnellere UX.
- „Fingerprint Pflicht?” → Nein. Touch‑only Standard vermeidet Lockouts. Per Policy aktivierbar.
- „macOS/Windows?” → Web‑Apps/Passkeys plattformweit; Linux OS‑Login heute; macOS sudo unterstützt.
- „Verlorene Schlüssel?” → Backup‑Key ausgeben; Mapping widerrufen; Nutzer arbeitet weiter.
- „500 an einem Tag?” → Multi‑Station‑Factory‑Ablauf mit CSV + vorab gebrieften Wellen.

---

## Packaging & Pricing Leitfaden
- Umfang: 1‑Tages‑Event onsite/remote bis 500 Nutzer inkl. Vorbereitung und Aftercare
- Preis: Fixpreis pro Event + optionale Per‑User Add‑ons (Training, Ersatzkeys)
- Hardware: Kundenseitig oder Beschaffung zum EK; Empfehlung 2 Keys/Nutzer
- Upsell: Trainings, Follow‑up Support, zusätzliche Rollout‑Tage

(Preise an Markt anpassen; simpel & fix halten für Speed.)

---

## Nächste Schritte für Kolleg:innen
 - Überblick lesen: [read_first_fido2_rollout_guide.md](./read_first_fido2_rollout_guide.md)
 - Runbook prüfen: [event_runbook_1day_500.md](../marketing/social_kit/event_runbook_1day_500.md)
 - Social/Email‑Kit für Discovery‑Calls nutzen: [social_kit](../marketing/social_kit/)
- 3‑Minuten‑Demo üben; Pilot ansetzen oder 1‑Tages‑Termin festlegen

Kontakt: Christoph Backhaus (IT/Security) – Support und Delivery
