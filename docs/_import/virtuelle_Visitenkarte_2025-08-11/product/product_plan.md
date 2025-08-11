# Product Plan – NADOO FIDO2 Program

Version: 2025‑08‑10

## 1) Offering Summary
- Product: End‑to‑end rollout of phishing‑resistant FIDO2 security keys for SMB/enterprise.
- Components:
  - nadoo‑key CLI (Linux provisioning, sudo + login, factory mode, integration hook)
  - Onboarding assets (handouts EN/DE for business, end‑users, managers, helpdesk)
  - Optional integrations (API/queue via `scripts/integrations/service_register.sh`)
  - Training and support packages

## 2) Ideal Customer Profile (ICP)
- Size: 25–500 employees (SMB/Mid‑market), departments inside larger orgs.
- Triggers: Cyber insurance requirements, phishing incidents, password‑reset cost, Zero Trust programs.
- Buyers: IT manager, Security lead, Ops; economic buyer often CFO/COO.

## 3) Value Proposition
- Security: Phishing‑resistant login (no passwords/OTP), strong MFA by default.
- Productivity: 1‑touch login; fewer lockouts; faster onboarding.
- Cost: Lower helpdesk volume; predictable rollout; minimal recurring cost.

## 4) Packaging
- Starter (≤25 users): Guided provisioning, policy setup, handouts, pilot support.
- Growth (26–250): Factory provisioning, CSV logging, optional service registration.
- Enterprise (250+): Custom policies, API integration, reporting, training, change mgmt.
- Add‑ons: Extra keys, onsite rollout, custom branding, ongoing support & monitoring.

## 5) Pricing Strategy (see pricing.md for numbers)
- Hardware pass‑through (50–90€ per key typical) with volume sourcing.
- Professional services: fixed fee + per‑user or per‑key; day‑rate for custom work.
- Optional support subscription for updates, policy changes, and escalations.
- Goal: 60–70% blended gross margin on services; 0–10% on hardware (optional).

## 6) Cost Structure (internal)
- Labor: engineering (provisioning, PAM, integration), PM/CS, training.
- Tools: test devices, packaging, travel/onsite costs (if any).
- Risk: scope creep → enforce assumptions in proposals.

## 7) Go‑To‑Market
- Channels: direct sales (email/LinkedIn), MSP/VAR partners, cyber‑insurance brokers, hardware vendors.
- Offers: free ROI estimate, 14‑day pilot for 5–10 users, bundle with security awareness.
- Collateral: `docs/handouts/` (EN/DE), case studies, proposal template.

## 8) Sales Process
- Discovery → ROI/Plan → Pilot → Exec buy‑in → Contract → Factory provisioning → Rollout → Training → Support.
- Close plan: confirm success criteria (reduced resets, login success, user satisfaction).

## 9) Delivery & Operations
- Use `nadoo-key` for guided/factory provisioning; default PIN 0000 for new keys; touch‑only login by default; fingerprint optional (UV toggles).
- CSV logging; optional external registration via `SERVICE_URL`.
- Documentation hand‑off; helpdesk SOP; training.

## 10) Legal & Compliance
- Data: no personal data collected by tooling; PAM mapping local.
- Contracts: MSA + SOW; liability cap; hardware warranty via manufacturer.

## 11) Metrics & Proof
- KPIs: password resets/user/month, login success rate, time‑to‑onboard, helpdesk ticket volume.
- Pilot target: ≥80% reduction in resets; ≤2s median login; ≥90% user satisfaction.

## 12) Roadmap
- Cross‑platform parity (macOS sudo, Windows flows), simple TUI/GUI, optional local vault (LUKS2 wrapper).
- Reporting dashboard (adoption, policy compliance), automated fleet checks.
