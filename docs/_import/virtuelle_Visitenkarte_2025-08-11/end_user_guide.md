# End‑User Guide: Your Analytics Device

Welcome! This guide shows how to open, use, and manage the local analytics app from your phone or computer.

## What you need
- Your phone or a computer on the same Wi‑Fi as the device
- The device’s address (on the sticker/label), e.g. `http://analytics.local:5001` or an IP like `http://192.168.1.50:5001`

## Open the app
1. Connect your phone or computer to the same Wi‑Fi as the device.
2. In your browser (Chrome/Safari/Edge), type the address from the sticker, for example:
   - `http://analytics.local:5001` (preferred) or
   - `http://<DEVICE_IP>:5001`
3. The home page appears with two main actions.

Tip: Add it to your phone’s Home Screen for quick access.

## Common tasks
- Create a customer page (invite):
  1. Tap “Create a customer page (invite)”.
  2. Enter the customer’s name and email.
  3. Tap Submit. You’ll see their landing page and a page path you can share.

- Download a sample analytics export:
  - Tap “Download sample analytics ZIP” to get a small example file.

## Starting and stopping the app
- The app is set to start automatically when the device powers on.
- To restart the app, simply power cycle the device (turn it off and on again).
- If the app doesn’t appear at the address, wait ~30 seconds after power‑on and try again.

If your device includes a simple power button:
- Press and hold to shut down.
- Press again to start.

(Advanced/installer managed) The app can also be controlled by the device’s service manager. If you have an admin contact, they can start/stop/restart the app remotely.

## Check if the device is running
- Open: `http://analytics.local:5001/health`
  - If you see `{ "status": "ok" }`, the app is running.

## Troubleshooting
- Page won’t load:
  - Confirm Wi‑Fi is connected on both phone/computer and the device.
  - Try the IP address instead of the name (e.g. `http://192.168.1.50:5001`).
  - Power off the device, wait 10 seconds, and turn it on again. Wait ~30 seconds, then try the address again.
- I forgot the address:
  - Check the sticker/label that came with the device.
  - Ask your admin contact.

## Privacy & security
- This app runs locally on your network. Only devices on your Wi‑Fi can access it.
- It does not expose your data to the public internet unless specifically configured by an admin.

## Need help?
- Contact your installer or admin for support.
