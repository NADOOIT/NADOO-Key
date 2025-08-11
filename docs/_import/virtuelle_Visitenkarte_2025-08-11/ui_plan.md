# UI Plan

This document outlines the near-term and future direction for the project's user interfaces.

## Current State
- Web: `index.html` mock page with placeholder JS actions (no real backend).
- Desktop: Tkinter apps (`dashboard.py`, `dashboard2.py`, `MeetLiveDashboard.py`) that visualize extracted CSVs.
- Tests: Minimal Flask harness under `test_harness/app.py` for invite/unique-link simulation.

## Near-Term Direction (Web via Jinja)
- Adopt Jinja templates rendered by a lightweight Flask app (local dev/testing) and/or by WP plugins that support server-side templates.
- Template structure proposal (`templates/`):
  - `base.html` — navbar, footer, common scripts/styles.
  - `invite.html` — form to accept name/email/token.
  - `landing.html` — generated single-page profile; can include referral context ("X said we should talk").
  - `partials/` — components (hero, contact card, referral badge, CTA buttons).
- Static assets under `static/` (CSS/JS/images), fingerprinted for cache busting in production.
- Integrate with the test harness: update routes to render `invite.html` and `landing.html` using Jinja.

## Desktop Direction (Tkinter for now)
- Keep Tkinter UIs operational.
- Refactor data/plot logic into pure functions (e.g., `analytics/core.py`), then import from Tkinter apps.
  - Benefits: unit-testable analytics without GUI.
  - Tests can run headless (matplotlib Agg backend already configured in tests).
- Long-term: evaluate alternatives (e.g., PySide/Qt, Kivy, Electron/neutralino frontends with a Python backend) for richer UX.

## Migration Steps
1. Create Flask app layout:
   - `app.py` (already available under `test_harness/`) -> expand with Jinja templates (`templates/` + `static/`).
2. Extract presentational HTML from `index.html` into `templates/base.html` and `templates/invite.html`.
3. Render dynamic values (e.g., token, referral name) via Jinja context.
4. Add simple integration tests in `tests/test_invite_flow.py` to assert template rendering (response codes, key strings).
5. (Optional) Bundle a minimal CSS framework (e.g., Pico.css/Tailwind) for consistent styling.

## Notes
- Jinja is already added to `requirements.txt`.
- The Flask harness is intended for local dev/testing only. Production deployment would be separate.
