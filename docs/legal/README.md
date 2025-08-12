# Rechtsdokumente (DE)

Vorlagen und Generator für Angebot, Rechnung, Verträge (inkl. AVV). Keine Rechtsberatung — bitte rechtlich prüfen lassen.

## Firmenangaben anpassen
Bearbeiten Sie `docs/legal/company.env` (aus Impressum vorbelegt).

## Beispiele ausfüllen
Beispiel-Variablen liegen in `docs/legal/examples/*.env`.

## Dokument erstellen
```bash
# Angebot
bash tools/legal/gen_doc.sh angebot  docs/legal/out/Angebot_Muster.md  docs/legal/examples/angebot_beispiel.env

# Rechnung
bash tools/legal/gen_doc.sh rechnung docs/legal/out/Rechnung_2025-001.md docs/legal/examples/rechnung_beispiel.env

# Vertrag (IT-Dienstleistung)
bash tools/legal/gen_doc.sh vertrag  docs/legal/out/Vertrag_Muster.md  docs/legal/examples/vertrag_beispiel.env

# AVV (Auftragsverarbeitung)
bash tools/legal/gen_doc.sh avv      docs/legal/out/AVV_Muster.md      docs/legal/examples/avv_beispiel.env
```

Der Generator schreibt Markdown (`.md`). Optional wird `.pdf` erzeugt, falls `pandoc` installiert ist.

## Hinweise
- Variablen in Vorlagen sind `${SO_WIE_DIESE}`. Sie kommen aus `company.env` und Ihrer jeweiligen `*.env` Datei.
- Beträge/Steuer in Beispielen sind Platzhalter. Bitte anpassen.
- AVV/TOMs/Verträge bitte anwaltlich prüfen lassen.
