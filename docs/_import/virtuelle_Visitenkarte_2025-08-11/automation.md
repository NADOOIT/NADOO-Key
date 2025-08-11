# Automation: Selenium Export Flow

Scripts: `3in1.py`, `filter.py`, `daily.py`.

## Login & Navigation
- `webdriver_manager` installs ChromeDriver.
- Headless Chrome navigates to `https://meetlive.de/wp-login.php` and logs in using `WP_USERNAME`/`WP_PASSWORD`.
- Goes to Koko Analytics admin (e.g., `.../wp-admin/index.php?page=koko-analytics`).

## Export
- Clicks the CSV export button: `//form[@method='POST']/button[@type='submit']`.
- `wait_for_download(DOWNLOAD_DIR)` watches `~/Downloads` for a new `*.zip`.

## Extraction
- `extract_csv(zip_path, EXTRACT_DIR)` extracts the archive.
- Searches recursively for `event-click-tracker*.csv` and returns its path.

## Analysis
- `3in1.py` groups `Total` by either `Value` or `Unnamed: 0` and saves `analysis_result.png`.
- `filter.py` splits `Unnamed: 0` into `Page` and `Action`, filters by page substring, then charts totals by `Action`.

## Date Range (daily.py)
- Builds per-day URLs with `start_date`/`end_date` query params and triggers a download for each date.
- Note: Update `BASE_EXTRACT_DIR` to your OS path.

## Email (optional)
- `send_email(...)` uses `smtp.gmail.com:587` with TLS. Uncomment its call to enable.
