# Dashboards

Dashboards expect extracted CSVs under `EXTRACT_DIR` (default `~/Desktop/analytics_project/extracted`).

- `dashboard.py`
  - Loads `event-click-tracker.csv`
  - Extracts `Page` / `Action` and charts total clicks per action for a selected page

- `dashboard2.py`
  - Loads `event-click-tracker.csv` and `pages.csv`
  - Shows clicks by action and basic visitor/pageview stats

- `MeetLiveDashboard.py`
  - Aggregates per-day pageviews/visitors across folders (e.g., monthly)
  - Renders bar/pie charts and exposes sidebar filters

Tips:
- Normalize or filter page names consistently (e.g., `andreas` vs `andreas-shared`).
- Ensure the extracted structure matches dashboard expectations.
