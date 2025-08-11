# Proposal – FIDO2 Security Keys Rollout

Client: <Company>
Date: <YYYY‑MM‑DD>
Prepared by: NADOO‑IT / Christoph Backhaus

## 1. Executive Summary
We will deploy phishing‑resistant FIDO2 security keys to <users> users to reduce password resets and breach risk, with a simple, fast user experience (plug + touch). Rollout includes guided or factory provisioning, documentation, and training.

## 2. Objectives & Success Criteria
- ≥80% fewer password reset tickets within 60 days
- ≤2s median login time at lock screen and sudo prompts
- ≥90% user satisfaction in pilot survey

## 3. Scope of Work
- Policy workshop and rollout plan
- Provisioning (guided and/or factory mode) with CSV logging
- Linux login (GDM/lock screen) + sudo via pam_u2f; touch‑only default; fingerprint optional
- Optional: external service registration via integration hook (API/queue)
- Documentation/handouts for end‑users, managers, helpdesk (EN/DE)
- Training sessions (helpdesk, managers) as per package

## 4. Assumptions
- Hardware provided at cost (model selection agreed upfront); recommend 2 keys per user
- Network/admin access as needed; stakeholder availability for pilot and training
- macOS/Windows: web apps supported; OS login varies by platform (documented)

## 5. Timeline
- Pilot (5–10 users): 2 weeks
- Policy finalize + prep: 1 week
- Rollout (batch provisioning + distribution): 1–2 weeks depending on size

## 6. Pricing
Refer to Pricing section below (tailored to your user count and options).

### Package
- <Starter/Growth/Enterprise> package
- Optional add‑ons: <Support subscription / Integration / Onsite>

### Commercials (example)
- Setup (fixed): €<amount>
- Provisioning: <users> × €<rate> = €<amount>
- Integration: €<amount> (if selected)
- Training: €<amount> (if selected)
- Hardware (pass‑through): <units> × €<unit_cost> = €<amount>
- Total services: €<amount> (hardware billed at cost)

## 7. Payment & Terms
- 50% on signature, 50% on delivery (services). Hardware in advance or at shipment.
- MSA + SOW; liability cap; manufacturer warranty applies to hardware.

## 8. Team & Contact
- Lead / Security Engineering: Christoph Backhaus
- Delivery: NADOO‑IT

## 9. Acceptance
Name / Title: ____________________   Signature: ____________________   Date: __________
