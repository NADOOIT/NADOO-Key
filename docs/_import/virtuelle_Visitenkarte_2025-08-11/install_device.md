# Device Installation Guide (Installer/Admin)

This guide sets up the analytics app as a service on a Linux device (e.g., Ubuntu/Raspberry Pi). After setup, end users simply open the device address in a browser and use the app.

## 1) Prerequisites
- Linux device on the business Wi‑Fi
- Admin shell access (SSH or local)
- Packages:
  ```bash
  sudo apt update
  sudo apt install -y python3 python3-venv git
  # Optional (recommended): gunicorn for production WSGI
  # sudo apt install -y gunicorn
  # Optional (mDNS / nice hostname):
  # sudo apt install -y avahi-daemon libnss-mdns
  ```

## 2) Create app user and folder
```bash
sudo useradd -r -m -d /opt/analytics-app -s /usr/sbin/nologin analytics || true
sudo mkdir -p /opt/analytics-app
sudo chown -R $USER:$(id -gn) /opt/analytics-app
```

## 3) Deploy the code
```bash
cd /opt/analytics-app
# If copying from a build system, place files here instead of git clone
sudo -u $(id -un) git clone https://example.com/your/repo.git . || true

python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
# Optional: pip install gunicorn
chmod +x bin/run_server.sh
```

## 4) Configure environment (optional)
Create `/etc/default/analytics-harness` to override environment variables:
```ini
# /etc/default/analytics-harness
# Example overrides
# FLASK_ENV=production
# WP_BASE_URL=https://meetlive.de
# WP_LOGIN_URL=https://meetlive.de/wp-login.php
# SMTP_HOST=smtp.gmail.com
# SMTP_PORT=587
```
A template is provided at `deploy/systemd/analytics-harness.env.example`.

## 5) Install systemd service
```bash
sudo cp deploy/systemd/analytics-harness.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now analytics-harness
```

Check status and logs:
```bash
systemctl status analytics-harness --no-pager
journalctl -u analytics-harness -n 200 --no-pager
```

## 6) Network address and firewall
- App listens on port 5001 to all interfaces by default via `bin/run_server.sh`.
- End users open: `http://<DEVICE_IP>:5001/` (or `http://analytics.local:5001/` if mDNS is enabled)
- If firewall active, allow the port:
  ```bash
  sudo ufw allow 5001/tcp
  ```

## 7) Optional: mDNS (friendly name)
Install Avahi (step 1) and ensure service is running:
```bash
sudo systemctl enable --now avahi-daemon
```
Users can then visit `http://analytics.local:5001/` on most networks.

## 8) Update/upgrade
```bash
cd /opt/analytics-app
sudo -u $(id -un) git pull
source .venv/bin/activate
pip install -r requirements.txt
sudo systemctl restart analytics-harness
```

## 9) Health check
- From a browser: `http://<DEVICE_IP>:5001/health` → `{ "status": "ok" }`

## 10) Uninstall
```bash
sudo systemctl disable --now analytics-harness
sudo rm -f /etc/systemd/system/analytics-harness.service
sudo systemctl daemon-reload
# Optional: remove app files
# sudo rm -rf /opt/analytics-app
```
