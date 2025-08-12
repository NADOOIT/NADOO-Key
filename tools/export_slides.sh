#!/usr/bin/env bash
set -Eeuo pipefail

# export_slides.sh — Convert HTML decks to PDFs if a converter is available.
# Usage: tools/export_slides.sh
# Looks for: chromium/chromium-browser/google-chrome/brave-browser/microsoft-edge,
#            wkhtmltopdf, or weasyprint.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PRESENT_DIR="$SCRIPT_DIR/../docs/presentations"
cd "$PRESENT_DIR"

in_en="fido2_pitch_en.html"; out_en="fido2_pitch_en.pdf"
in_de="fido2_pitch_de.html"; out_de="fido2_pitch_de.pdf"

html_to_pdf() {
  local in="$1" out="$2"
  for CH in chromium chromium-browser google-chrome google-chrome-stable brave-browser microsoft-edge; do
    if command -v "$CH" >/dev/null 2>&1; then
      echo "[+] Using $CH (headless) to export $in -> $out"
      "$CH" --headless --disable-gpu --print-to-pdf="$PWD/$out" "file://$PWD/$in"
      return 0
    fi
  done
  if command -v wkhtmltopdf >/dev/null 2>&1; then
    echo "[+] Using wkhtmltopdf to export $in -> $out"
    wkhtmltopdf --print-media-type "$in" "$out"
    return 0
  fi
  if command -v weasyprint >/dev/null 2>&1; then
    echo "[+] Using weasyprint to export $in -> $out"
    weasyprint "$in" "$out"
    return 0
  fi
  echo "[x] No HTML->PDF tool found (chromium/chrome/wkhtmltopdf/weasyprint)." >&2
  return 1
}

html_to_pdf "$in_en" "$out_en" || true
html_to_pdf "$in_de" "$out_de" || true

ls -lh *.pdf 2>/dev/null || true
