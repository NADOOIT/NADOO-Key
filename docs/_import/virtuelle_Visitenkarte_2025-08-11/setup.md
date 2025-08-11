# Setup

- __Python__: 3.10+ recommended
- __Chrome__: install Google Chrome (WebDriver handled by `webdriver_manager`)
- __Virtualenv__:
  ```bash
  python -m venv .venv
  source .venv/bin/activate  # Windows: .venv\\Scripts\\activate
  pip install -r requirements.txt
  ```
- __Dotenv__:
  - Create `.env` in project root based on `.env.example`.
  - Scripts call `load_dotenv()` at startup.
- __WordPress__: admin user with access to Koko Analytics.
- __REST (optional)__: create a WP Application Password for the account used by `koko_export/export_analytics.py`.

## Environment Variables
- `WP_USERNAME`, `WP_PASSWORD` (required for Selenium)
- `SMTP_USER`, `SMTP_PASSWORD`, `RECIPIENT_EMAIL` (optional for email)
- `SITE_URL`, `USERNAME`, `APP_PASS` (optional for REST exporter)

## Verify install
- `python -c "import selenium, pandas, matplotlib; print('ok')"`
- If using REST exporter: `python -c "import requests; print('ok')"`

## Notes
- Linux GUI: Tkinter dashboards require a graphical session (X11/Wayland).
- Corporate networks and 2FA can interfere with Selenium logins.
