# Start Here: Daily Workflow

This is the shortest path to a productive day. One command to remember: `make`.

> Note: This page is for developers/advanced users. For non‑technical end users, see `docs/end_user_guide.md`.

## 1) Setup (first time)
- Create a venv and install deps:
  ```bash
  python -m venv .venv
  source .venv/bin/activate  # Windows: .venv\Scripts\activate
  pip install -r requirements.txt
  ```
- Copy env template and fill values you use:
  ```bash
  cp .env.example .env
  ```
  - Required for Selenium export: `WP_USERNAME`, `WP_PASSWORD`
  - Optional: SMTP (`SMTP_USER`, `SMTP_PASSWORD`, `RECIPIENT_EMAIL`), REST (`SITE_URL`, `USERNAME`, `APP_PASS`)

### Security Keys (FIDO2)
- For local login/sudo and factory provisioning, use the standalone NADOO-Key CLI.
  See https://github.com/NADOOIT/NADOO-Key

### Optional: NADOO integrations
  - To use NADOO backend/services and the Launchpad toolkit, see `docs/integrations.md`.
  - Bootstrap external repos (NADOO-IT + Launchpad CLI branch):
  ```bash
  make external            # clones/updates under external/
  make external:status     # show remotes, branches, SHAs
  ```
  - If you work on Launchpad in a separate clone, point this project to it:
  ```bash
  LP_DEV_PATH=/abs/path/to/your/NADOO-Launchpad make external
  ```
  - To pin exact SHAs for collaborators (recommended for reproducibility):
  ```bash
  make external:lock       # writes external/external.lock (tracked)
  git add external/external.lock && git commit -m "lock externals"
  ```

## 2) Start your day
- Run the default dev workflow (safety suggestions + tests with coverage):
  ```bash
  make
  ```
  This gives quick safety hints and verifies the codebase with tests.
  
  If `make` is not installed, use the Python-only entrypoint:
  ```bash
  python dev.py
  ```

## 3) Try the local harness (invite flow)
- Start the harness:
  ```bash
  make harness
  ```
  If `make` is not installed:
  ```bash
  python -m flask --app test_harness/app.py run -p 5001
  ```
- Open http://127.0.0.1:5001/start
- Enter email + name → you get a simple landing page. This simulates the unique‑link flow used by the website.

## 4) Create the analytics chart
You have two main paths:

- Path A — Full pipeline via Selenium (real WordPress):
  ```bash
  python 3in1.py
  ```
  - Downloads Koko Analytics export ZIP
  - Extracts it to `EXTRACT_DIR`
  - Creates a chart image at `OUTPUT_IMAGE`

- Path B — Dashboards on already extracted CSVs (no Selenium):
  ```bash
  python dashboard.py
  # or
  python dashboard2.py
  # or
  python MeetLiveDashboard.py
  ```
  These load CSVs from `EXTRACT_DIR` and show Tkinter dashboards.

Notes:
- `3in1.py` uses these defaults (edit in file if needed):
  - `DOWNLOAD_DIR = ~/Downloads`
  - `EXTRACT_DIR = ~/Desktop/analytics_project/extracted`
  - `OUTPUT_IMAGE = ~/Desktop/analytics_project/analysis_result.png`
- `daily.py` contains a Windows path example. Update it before using on Linux/macOS.

## 5) Improve tests and safety (as needed)
- Coverage report:
  ```bash
  make coverage
  ```
- Coverage suggestions / stubs:
  ```bash
  make coverage:suggest
  make coverage:stubs
  ```
- Data safety suggestions (non‑binding):
  ```bash
  make safety
  ```
- Security checks (optional):
  ```bash
  make security:bandit
  make security:audit
  ```

## 6) Where to look next
- REST exporter: `koko_export/export_analytics.py`
- Tests examples: `tests/` (see `tests/test_3in1.py`)
- UI migration plan: `docs/ui_plan.md`

---
If behavior changes, update this page immediately to keep onboarding accurate.
