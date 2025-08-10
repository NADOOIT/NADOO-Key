# Handouts – FIDO2 Program

This folder contains audience‑specific handouts for rollout and operations.

## English
- Business customer handout: `fido2_customer_handout.md`
- End‑user quick start: `fido2_end_user_quick_start.md`
- Manager brief: `fido2_manager_brief.md`
- Helpdesk SOP: `fido2_helpdesk_sop.md`
- Older employees guide: `fido2_older_adults_guide.md`

## Deutsch
- Kundenhandout: `fido2_kundenhandout.md`
- End‑User Kurzanleitung: `fido2_end_user_kurzanleitung.md`
- Manager‑Kurzübersicht: `fido2_manager_kurzuebersicht.md`
- Helpdesk SOP: `fido2_helpdesk_sop_de.md`
- Leitfaden für ältere Mitarbeitende: `fido2_aeltere_benutzer_leitfaden.md`

## Export to PDF (optional)
If Pandoc is installed:

```bash
pandoc -V geometry:margin=1in -o fido2_customer_handout.pdf fido2_customer_handout.md
pandoc -V geometry:margin=1in -o fido2_kundenhandout.pdf fido2_kundenhandout.md
pandoc -V geometry:margin=1in -o fido2_end_user_quick_start.pdf fido2_end_user_quick_start.md
pandoc -V geometry:margin=1in -o fido2_end_user_kurzanleitung.pdf fido2_end_user_kurzanleitung.md
pandoc -V geometry:margin=1in -o fido2_manager_brief.pdf fido2_manager_brief.md
pandoc -V geometry:margin=1in -o fido2_manager_kurzuebersicht.pdf fido2_manager_kurzuebersicht.md
pandoc -V geometry:margin=1in -o fido2_helpdesk_sop.pdf fido2_helpdesk_sop.md
pandoc -V geometry:margin=1in -o fido2_helpdesk_sop_de.pdf fido2_helpdesk_sop_de.md
pandoc -V geometry:margin=1in -o fido2_older_adults_guide.pdf fido2_older_adults_guide.md
pandoc -V geometry:margin=1in -o fido2_aeltere_benutzer_leitfaden.pdf fido2_aeltere_benutzer_leitfaden.md
```

We can add a Makefile target (e.g., `make handouts:pdf`) if desired.
