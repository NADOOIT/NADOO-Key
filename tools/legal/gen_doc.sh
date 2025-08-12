#!/usr/bin/env bash
set -Eeuo pipefail

# gen_doc.sh — Füllt deutsche Rechtsvorlagen mit Variablen und erzeugt Markdown (+ optional PDF)
# Nutzung:
#   tools/legal/gen_doc.sh angebot  out/Angebot_Muster.md  docs/legal/examples/angebot_beispiel.env
#   tools/legal/gen_doc.sh rechnung out/Rechnung_2025-001.md docs/legal/examples/rechnung_beispiel.env
#   tools/legal/gen_doc.sh vertrag  out/Vertrag_Muster.md  docs/legal/examples/vertrag_beispiel.env
#   tools/legal/gen_doc.sh avv      out/AVV_Muster.md      docs/legal/examples/avv_beispiel.env
#
# Erzeugt zusätzlich PDF, falls pandoc oder wkhtmltopdf/weasyprint verfügbar sind.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
TEMPL_DIR="$ROOT_DIR/docs/legal/templates"
COMPANY_ENV="$ROOT_DIR/docs/legal/company.env"

usage() { echo "Usage: $0 {angebot|rechnung|vertrag|avv} OUT.md VARS.env" >&2; exit 1; }
[[ $# -ne 3 ]] && usage
KIND="$1"; OUT_MD="$2"; VARS_ENV="$3"

case "$KIND" in
  angebot)  TEMPLATE="$TEMPL_DIR/angebot_de.md" ;;
  rechnung) TEMPLATE="$TEMPL_DIR/rechnung_de.md" ;;
  vertrag)  TEMPLATE="$TEMPL_DIR/vertrag_it_dienstleistung_de.md" ;;
  avv)      TEMPLATE="$TEMPL_DIR/avv_de.md" ;;
  *) usage ;;
esac

[[ -f "$TEMPLATE" ]] || { echo "Template not found: $TEMPLATE" >&2; exit 1; }
[[ -f "$COMPANY_ENV" ]] || { echo "Company file missing: $COMPANY_ENV" >&2; exit 1; }
[[ -f "$VARS_ENV" ]] || { echo "Vars file missing: $VARS_ENV" >&2; exit 1; }

mkdir -p "$(dirname "$OUT_MD")"

# Export variables from env files
set -a
. "$COMPANY_ENV"
. "$VARS_ENV"
# Convenience defaults
DATE="${DATE:-$(date +%Y-%m-%d)}"
VALID_UNTIL="${VALID_UNTIL:-$(date -d "+14 days" +%Y-%m-%d 2>/dev/null || date -v+14d +%Y-%m-%d)}"
set +a

# Render via envsubst
if ! command -v envsubst >/dev/null 2>&1; then
  echo "[x] envsubst fehlt. Installieren Sie: gettext-base" >&2; exit 1
fi

envsubst <"$TEMPLATE" >"$OUT_MD"
echo "[✓] Geschrieben: $OUT_MD"

# Try to produce PDF next to it if possible
OUT_PDF="${OUT_MD%.md}.pdf"
make_pdf() {
  local in_md="$1" out_pdf="$2"
  if command -v pandoc >/dev/null 2>&1; then
    pandoc "$in_md" -o "$out_pdf"
    return $?
  fi
  # HTML path via markdown (requires a browser-like engine)
  if command -v weasyprint >/dev/null 2>&1; then
    # convert MD -> HTML using basic pandocless method is non-trivial; skip if pandoc absent
    return 1
  fi
  if command -v wkhtmltopdf >/dev/null 2>&1; then
    # Same: need HTML; skip here to keep deps simple
    return 1
  fi
  return 1
}

if make_pdf "$OUT_MD" "$OUT_PDF"; then
  echo "[✓] PDF erzeugt: $OUT_PDF"
else
  echo "[i] Kein PDF erzeugt (pandoc nicht gefunden). Markdown ist erstellt."
fi
