NADOO-Key Installer USB

How to use:

Linux
1) Insert this USB stick.
2) Open the drive and double-click start_linux.sh (or the .desktop file) and allow execution.
3) Follow prompts. When asked, unplug the USB and plug your FIDO2 key.

macOS
1) Insert this USB stick.
2) Double-click "Start NADOO-Key Installer.command".
3) You will see guidance and limitations: macOS supports passkeys in browsers and sudo via pam_u2f (advanced), but not OS login.

Windows
1) Insert this USB stick.
2) Double-click Start-NADOO-Key-Installer.cmd. Approve the admin prompt.
3) You will see guidance (Windows OS login with FIDO2 is not supported yet). WebAuthn setup is browser-based.

Notes
- Modern operating systems block automatic execution from USB for security. A double-click is required.
- Linux provisioning is fully automated (login/sudo via pam_u2f, touch-only by default, fingerprint optional).
- macOS and Windows provisioning are limited today; full support planned. See repository docs for updates.
