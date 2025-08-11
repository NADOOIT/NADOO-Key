# Data Model (CSV Exports)

Koko Analytics export typically contains:

- `event-click-tracker.csv`
  - Columns often include: `Unnamed: 0` (or `Value`), `Unique`, `Total`, `Value`
  - `3in1.py` uses `Value` if non-empty; falls back to `Unnamed: 0`
  - `filter.py` splits `Unnamed: 0` by `": "` into `Page` and `Action`

- `pages.csv`
  - Contains page URL/title and metrics like `Visitors`, `Pageviews`

- `referrers.csv`
  - Contains referrer URL and metrics like `Visitors`, `Pageviews`

Notes:
- Header names can vary by plugin version/export format; scripts log available columns to help diagnose.
- Ensure the export contains `event-click-tracker*.csv`, otherwise analysis scripts will raise a `FileNotFoundError`.
