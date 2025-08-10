# Handouts – FIDO2 Program

This folder contains audience‑specific handouts for rollout and operations.

## English
 - [Business customer handout](./fido2_customer_handout.md)
 - [End‑user quick start](./fido2_end_user_quick_start.md)
 - [Manager brief](./fido2_manager_brief.md)
 - [Helpdesk SOP](./fido2_helpdesk_sop.md)
 - [Older employees guide](./fido2_older_adults_guide.md)
 - [Teens & students](./fido2_teens_students.md)
 - [Young professionals](./fido2_young_professionals.md)
 - [Busy parents](./fido2_busy_parents.md)

## Deutsch
 - [Kundenhandout](./fido2_kundenhandout.md)
 - [End‑User Kurzanleitung](./fido2_end_user_kurzanleitung.md)
 - [Manager‑Kurzübersicht](./fido2_manager_kurzuebersicht.md)
 - [Helpdesk SOP](./fido2_helpdesk_sop_de.md)
 - [Leitfaden für ältere Mitarbeitende](./fido2_aeltere_benutzer_leitfaden.md)
 - [Teenager & Schüler:innen](./fido2_teenager_schueler.md)
 - [Junge Berufstätige](./fido2_junge_berufstaetige.md)
 - [Beschäftigte Eltern](./fido2_beschaeftigte_eltern.md)

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
pandoc -V geometry:margin=1in -o fido2_teens_students.pdf fido2_teens_students.md
pandoc -V geometry:margin=1in -o fido2_young_professionals.pdf fido2_young_professionals.md
pandoc -V geometry:margin=1in -o fido2_busy_parents.pdf fido2_busy_parents.md
pandoc -V geometry:margin=1in -o fido2_teenager_schueler.pdf fido2_teenager_schueler.md
pandoc -V geometry:margin=1in -o fido2_junge_berufstaetige.pdf fido2_junge_berufstaetige.md
pandoc -V geometry:margin=1in -o fido2_beschaeftigte_eltern.pdf fido2_beschaeftigte_eltern.md
```

We can add a Makefile target (e.g., `make handouts:pdf`) if desired.

