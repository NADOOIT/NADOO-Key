# Testing

This project includes a comprehensive PyTest setup to test the automation, analysis, email sending, REST exporter, and a minimal invite/unique‑link flow — without any real WordPress instance.

## Quick start
```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
pytest -q
```

## Useful workflows
- Run coverage:
  ```bash
  make coverage
  ```
- Suggest tests for uncovered code (non-destructive):
  ```bash
  make coverage:suggest
  ```
- Scaffold test stubs under `tests/suggestions/` (you can edit or delete):
  ```bash
  make coverage:stubs
  ```
- Data safety suggestions (non-binding):
  ```bash
  make safety
  ```
- Security checks (optional; non-blocking):
  ```bash
  make security:bandit
  make security:audit
  ```

- Run the local Flask test harness (simulates invite/unique-link):
  ```bash
  make harness
  ```

## What is covered
- Export ZIP handling: extraction and discovery of `event-click-tracker.csv`
- Analysis and chart generation using sample CSVs
- Email sending (mocked via DummySMTP)
- `daily.py` date‑range flow with dummy Selenium objects
- REST exporter with mocked HTTP
- Minimal Flask app fixture that simulates an invite link and page generation

## Notes
- Dashboards (`dashboard.py`, `dashboard2.py`, `MeetLiveDashboard.py`) currently initialize Tkinter on import. For testability, consider refactoring the data‑loading/plotting logic into pure functions in a separate module (e.g., `analytics/core.py`) and import those in dashboards. Then we can unit‑test the core logic easily.
- Matplotlib uses the non‑interactive `Agg` backend during tests.
