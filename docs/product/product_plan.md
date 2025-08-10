# Product Plan — NADOO-Key

Goal: Deliver a turnkey FIDO2 rollout toolkit with CLI-first automation and a path to cross-platform UI.

## Pillars
- Phishing-resistant authentication made simple (touch-only by default; fingerprint optional)
- One-button setup for individuals and factory provisioning at scale
- Reliable Linux login + sudo today; web apps on all platforms; track platform login options

## Roadmap (high-level)
1) CLI Foundation (Linux)
   - Provision, register, login/sudo PAM setup, troubleshooting helpers
   - Factory mode + CSV + integration hook (`SERVICE_URL`)
   - Vault (optional) via LUKS + `systemd-cryptenroll`
2) Packaging & Onboarding
   - Polished docs/handouts (EN/DE), helpdesk SOP, runbooks
   - Deb/rpm packaging or install script for wider distribution
3) Cross-Platform Expansion
   - macOS: sudo via pam_u2f, docs for browser passkeys; test YubiKey Bio support nuances
   - Windows: document passkeys/webauthn usage; explore local login via vendor tools (roadmap)
4) UI/Toolkit (Optional)
   - Lightweight GUI (PySimpleGUI/Tkinter) wrapping CLI flows
   - NADOO-Launchpad integration for org onboarding and branding
5) Ops & Feedback
   - Telemetry-free by default; optional success metrics via integration hook
   - Collect rollout feedback to refine defaults and docs

## Defaults & Policy
- New keys initialize with PIN 0000 (changeable per policy)
- Login defaults: touch-only; enable UV via `REQUIRE_UV_LOGIN/REQUIRE_UV_SUDO`
- Multi-fingerprint enrollment supported (interactive or `FINGERPRINTS=N`)

## Deliverables
- CLI (`./bin/nadoo-key`), Makefile workflows, docs and handouts (EN/DE)
- Factory provisioning artifacts (CSV, optional API registration)
- Support contact and SOPs ready for helpdesk
