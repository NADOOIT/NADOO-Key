# start_windows.ps1 — NADOO‑Key guidance on Windows
# Note: Automatic execution from USB is blocked by Windows for security.
# Run via Start-NADOO-Key-Installer.cmd.

Write-Host "[+] NADOO‑Key (Windows)" -ForegroundColor Cyan
Write-Host "- Passkeys/WebAuthn work in browsers (Edge/Chrome/Firefox)."
Write-Host "- Windows sign-in with FIDO2 security keys requires Azure AD / Hybrid AD configuration (enterprise IT)." -ForegroundColor Yellow
Write-Host "- This helper will open the README and FIDO Alliance resources." 

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoDir = Join-Path $scriptDir 'nadoo-key'

# Open local README if present
$readme = Join-Path $repoDir 'README.md'
if (Test-Path $readme) { Start-Process $readme -ErrorAction SilentlyContinue }

# Open external references
Start-Process "https://fidoalliance.org/passkeys/" -ErrorAction SilentlyContinue
Start-Process "https://www.yubico.com/works-with-yubikey/catalog/" -ErrorAction SilentlyContinue

Write-Host "Done. Close this window when finished." -ForegroundColor Green
