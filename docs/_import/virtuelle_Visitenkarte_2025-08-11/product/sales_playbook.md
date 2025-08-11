# Sales Playbook – NADOO FIDO2 Program

Version: 2025‑08‑10

## 1) ICP and Triggers
- ICP: 25–500 employees; IT‑led security initiatives; regulated/lightly regulated; Linux presence a plus.
- Triggers: phishing incidents, cyber‑insurance mandates, password‑reset ticket volume, Zero Trust roadmap, new device rollout.

## 2) Discovery (questions)
- Security: “Any recent phishing or account takeover?” “MFA coverage today?”
- Operations: “How many password resets per month?” “Onboarding time per hire?”
- Estate: “OS mix? Linux desktops/servers?” “Sudo usage?” “IdP/SSO stack?”
- Policy: “Biometrics allowed/required?” “Backup key policy?”
- Org: “Target pilot team?” “Executive sponsor?”

## 3) Talk Track (problem → value → proof)
- Problem: passwords + OTP/app prompts are phishable and expensive to support.
- Value: FIDO2 keys deliver 1‑touch, phishing‑resistant login; reduce resets by up to 80%.
- Proof: Big Tech, banks, public sector. We ship factory provisioning + handouts to make rollout painless.
- Outcome: faster logins, fewer tickets, happier users, lower breach risk.

## 4) Demo Flow (5–7 min)
1) Touch‑only login on Linux lock screen (no password).
2) Sudo with key touch; toggle fingerprint policy.
3) `factory` mode provisioning with CSV + optional `SERVICE_URL` integration.
4) Show handouts for end‑users/managers/helpdesk.

## 5) Objection Handling
- “We already have MFA.” → Traditional MFA is phishable; FIDO2 is phishing‑resistant and faster.
- “Users will hate new tokens.” → Plug + touch; simpler than OTP/apps; older‑adult guides available.
- “Too much rollout effort.” → Factory mode, CSV logging, SOPs; pilot in 14 days.
- “Cost?” → Resets cost 15–70€ each; FIDO2 pays back in ≤3y, often faster.

## 6) ROI Script (live math)
- Baseline reset cost = users × resets/user/yr × 30€
- Savings (80% cut) = baseline × 0.8
- Services + hardware vs. annual savings ⇒ breakeven, then yearly gains.

## 7) Packaging & Price Cheat Sheet
- See `docs/product/pricing.md` for current tiers and examples.
- Starter ≤25, Growth 26–250, Enterprise 250+; support subscriptions optional.

## 8) Pilot Plan (14 days)
- Scope: 5–10 users, target team. Success metrics: ≥80% fewer resets, ≤2s median login, ≥90% satisfaction.
- Deliverables: provisioned keys, docs, helpdesk SOP, pilot report + rollout plan.

## 9) Close Plan
- Executive readout → confirm metrics → finalize scope/tiers → SOW/MSA → scheduling → factory provisioning.

## 10) Expansion Motions
- Add backup keys policy, extend to admins/contractors, integrate with service desk/asset CMDB, add support subscription.
