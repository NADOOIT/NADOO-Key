# REST Export (Alternative to Selenium)

Script: `koko_export/export_analytics.py`

- Endpoint: `GET {SITE_URL}/wp-json/koko-analytics/v1/stats`
- Auth: HTTP Basic (username + WP Application Password)
- Params: `start_date`, `end_date` (ISO `YYYY-MM-DD`)
- Output: writes stats rows to CSV

Setup:
- Generate an Application Password: WP Admin → Users → Your Profile → Application Passwords
- Set `SITE_URL`, `USERNAME`, `APP_PASS` via `.env` or edit the script constants
- Ensure `requests` is installed

Run:
```bash
python koko_export/export_analytics.py
```
