@echo off
setlocal

REM Windows launcher for NADOO‑Key from the USB root.
REM Admin recommended for any system changes.

set SCRIPT_DIR=%~dp0
set REPO_DIR=%SCRIPT_DIR%\nadoo-key

cls
ECHO [+] NADOO‑Key (Windows)
ECHO  - Passkeys/WebAuthn work in modern browsers.
ECHO  - Windows OS login with external FIDO2 security keys is not supported today.
ECHO  - This launcher will open guidance and attempt a PowerShell helper.

REM Try to run PowerShell helper with elevation
powershell -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%start_windows.ps1"

pause
