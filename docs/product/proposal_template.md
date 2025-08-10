# Proposal Template — FIDO2 Rollout with NADOO-Key

Client: <Customer Name>
Date: <YYYY-MM-DD>
Prepared by: NADOO‑IT

## 1. Objectives
- Deploy phishing‑resistant FIDO2 authentication with touch‑only defaults
- Enable Linux login + sudo; web app support organization‑wide
- Reduce password reset tickets and credential risk

## 2. Scope
- Users: <N total> (recommend 2 keys/user)
- Keys: <Model(s)>, backup policy: <yes/no>
- Platforms: Linux primary; macOS/Windows for web apps
- One‑day event rollout (up to 500) or phased pilot <describe>

## 3. Deliverables
- Provisioned keys with CSV log
- Linux login + sudo configured, GNOME lock screen supported
- Handouts and Helpdesk SOP (EN/DE)
- Optional integration hook to external IT (`SERVICE_URL`)

## 4. Approach & Timeline
- T‑7 to T‑1: logistics, policy, hardware check
- Day 0: pilot verification; factory provisioning; distribution
- Post: verification, report, support handoff

## 5. Assumptions
- Hardware available or sourced at cost
- Workstations available with admin rights
- Network access for package install and optional API

## 6. Pricing
- See [pricing.md](./pricing.md). Final pricing to be confirmed based on headcount, logistics, and options.

## 7. Risks & Mitigations
- Fingerprint lockouts → default touch‑only; PIN unlock SOP
- Bottlenecks → multiple stations and runners
- API downtime → queue/retry strategy

## 8. Acceptance Criteria
- Users can log in (lock screen) and use sudo with key touch
- CSV delivered; helpdesk briefed; SOP tested

## 9. Contacts
- Technical: Christoph Backhaus
- Operations/PM: <Name>
