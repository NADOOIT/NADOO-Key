# Email Reporting

`3in1.py` and `filter.py` define `send_email(smtp_user, smtp_password, recipients, subject, body, attachment)`.

Config:
- SMTP host: `smtp.gmail.com`
- Port: `587`
- TLS: `server.starttls()`
- Credentials: `SMTP_USER`, `SMTP_PASSWORD` (consider app passwords)
- Recipient: `RECIPIENT_EMAIL` (single or comma-separated)

Usage:
- Uncomment the `send_email(...)` call in `main()` once your SMTP vars are set.
- Attachment is the generated chart image (e.g., `analysis_result.png`).

Security:
- Store secrets in `.env` and never commit them.
- For Gmail, use App Passwords if using regular accounts with 2FA.
