# Ideas: PWA Digital Card and Direct Communication

This file captures ideas for the next phase: turning each digital business card into an installable PWA with built‑in contact actions and our own direct, peer‑to‑peer communication.

## Vision
- Installable “app” per card (Add to Home Screen) that works offline, loads instantly, and keeps a direct link to that person.
- One tap to call, message, WhatsApp, Telegram, email, or open social links.
- Our own privacy‑preserving direct chat/video calling via P2P; optional bridges to Telegram/WhatsApp through NADOO‑IT.
- Minimal or no personal data collection; user‑controlled identity. Owners verify via WebAuthn/FIDO2 to manage their card.

## PWA Feature Set
- Installable: `manifest.json` (name, icons, theme color), service worker, HTTPS.
- Offline/fast: cache‐first shell with Workbox; offline fallback page.
- Shortcuts: app shortcuts for “Call”, “Message”, “WhatsApp”, “Telegram”.
- Web Share APIs: share the card; receive shares (Share Target) for quick contact.
- Deep links/QR: per‑person QR code and short link on the card.
- vCard export: “Add to contacts” button generating `.vcf`.
- Theming/branding: per‑card color/logo; light/dark; localization.
- Web Push: optional notifications for new messages/missed calls.

## Contact & Social
- Primary actions: `tel:`, `sms:`, `mailto:`.
- WhatsApp deep link: `https://wa.me/<NUMBER>`.
- Telegram: `https://t.me/<USERNAME>` or start chat link.
- Social grid: LinkedIn, Instagram, X/Twitter, YouTube, etc.
- Scheduling link: Calendly/ICS export.

## Cross-Device Handoff (Send to my computer)
- Goal: make it trivial to open the card on another device without Bluetooth pairing.
- Primary flow (code portal):
  - From phone, choose “Open on my computer”. We generate a 6‑digit code and show `go.nadooit.de`.
  - On the computer, open `go.nadooit.de`, enter the code, and the page opens instantly.
  - Behind the scenes: short‑lived token + optional WebRTC datachannel for handoff (use NADOO‑IT STUN/TURN in prod).
- Alternatives:
  - Web Share to self (email, “Saved Messages” in Telegram/WhatsApp) — 1 tap from share sheet.
  - Optional webcam QR on desktop (fallback; not the primary UX).
  - “NADOO Drop”: Snapdrop‑style page that discovers peers and transfers via WebRTC.

## Personal Share Links & Referral Context
- Each share mints a unique short link (per‑recipient/per‑event), not the canonical card URL (e.g., `go.nadooit.de/s/<token>`).
- The link includes owner context (message, intro video, purpose) so recipients know why they got it.
- If forwarded, we can show that it was passed along (chain) and allow the new viewer to start their own thread.
- Controls: expiry, revoke, view‑count, and analytics (privacy‑preserving aggregates).
- Content ideas: intro video, “why talk”, collaboration summary, resources playlist.

## Card‑to‑Card Handshake (Compare cards)
- Two people open their cards and tap “Compare cards”.
- Establish a short P2P/WebRTC session (QR/code handshake) to exchange public profile tags/capabilities.
- Locally compute a “collaboration fit” summary and suggested next steps (Launchpad functions).
- Option to save the result as a note/reminder and share a link to the other’s card.

## Optimization Objectives & Learning
- Primary metric: minimize Time-to-Contact (TTC) from share to first meaningful contact. Instrument all share flows (code portal at `go.nadooit.de`, share-to-self, QR, NADOO Drop) to emit events and compute TTC.
- Secondary metric: maximize Contact Quality. Collect lightweight thumbs-up/down per contact thread (optional reason/tags). Translate downstream signals (reply, meeting booked/kept, follow-up, revenue) into weighted scores.
- Personalization loop:
  - Per-owner models that prioritize channels, messaging, and context to reduce TTC and increase quality.
  - A/B test share context (intro text/video), link type (personal link vs canonical), handoff UX, and slot presets.
  - Reuse Launchpad functions for analytics, i18n, timezone handling.
- Privacy & control: opt-in analytics, aggregate reporting, owner data deletion, store minimal metadata (no PII in logs).
- Product nudges: if TTC is high, suggest adding intro video or clearer purpose; if quality is low, refine audience tags or add handshake questions.
- Feedback UI: one-tap “Was this valuable?” with up/down and quick tags; show dashboard with TTC median/p90 and quality score by channel.

## Scheduling & Calendar Management
- Goal: enable visitors to book appointments via the card; owners manage availability across providers.
- Adapter architecture:
  - Interface: `getAvailability()`, `createEvent()`, `cancelEvent()`, `listCalendars()`, `linkAccount()`, `webhookHandler()`.
  - Providers: CalDAV (Nextcloud, iCloud), Google Calendar, Microsoft 365/Outlook, ICS-only (Cal.com/Calendly), local ICS.
  - Storage: tokens/refresh and per-owner config in NADOO-IT backend (encrypted at rest).
- Booking flow (PWA):
  - Visitor picks a slot from merged availability (timezone-aware, mobile-first UI).
  - Create event; send confirmations (email, Telegram/WhatsApp via NADOO-IT); attach `.ics`.
  - Optional Web Push reminders; reschedule/cancel links with signed tokens.
  - Meeting link generation: prefer NADOO-IT meeting service; fallback to P2P/WebRTC room (BitPeer adapter). Include join link in confirmations and `.ics`.
- Availability rules:
  - Pull provider free/busy; apply buffers, working hours, holidays; prevent double-booking.
  - Optional public WebCal feed for availability; owner-controlled.
- Privacy & auth:
  - Expose only slots/free-busy to visitors; never raw event details.
  - Owners authenticate with WebAuthn/FIDO2 to manage adapters and rules.
- Offline-first notes:
  - Cache recent slots; queue booking when offline and reconcile on reconnect (handle 409 conflicts with retry/alt-slot UX).
- Launchpad integration:
  - Reuse functions for timezones, i18n, notifications, testing scaffolds.
- Phased provider rollout:
  - Phase A: Google + ICS; Phase B: Microsoft 365 + CalDAV; Phase C: iCloud (app-specific passwords).

## Reminders & Follow-ups
- Use case: From a card, set "Remind me in 2 months to talk about <topic>". Not necessarily a meeting; can later convert to one.
- Data model: `topic`, `note`, `due` (absolute) or `in` (relative), link to card owner, optional `createMeetingLink` flag.
- Delivery channels: Web Push, email; optional Telegram/WhatsApp via NADOO-IT.
- Actions: `createReminder()`, `listReminders()`, `snoozeReminder()`, `completeReminder()`, `cancelReminder()`.
- UX:
  - Quick presets (tomorrow, next week, 1/2/3 months), or pick date/time.
  - Deep‑link back to the card. One‑tap "Convert to appointment" opens the slot picker.
  - If `createMeetingLink` is set, generate a NADOO-IT meeting link (preferred) or P2P room and include it in notification and optional `.ics`.
- Storage & privacy: store reminders in NADOO-IT (encrypted at rest); expose only to the requester; signed tokens for management links.
- Offline-first: queue creation and notification; reconcile on reconnect.

## Direct Communication (Own System)
- Transport: WebRTC (audio/video/data channels) for 1:1 calls and chat.
- Signaling: lightweight endpoint in NADOO‑IT (or a small dedicated service).
- NAT traversal: NADOO‑IT STUN/TURN (coturn) with credentials; HTTPS required.
- E2E security: DTLS‑SRTP (P2P). For group calls, consider SFU + insertable streams.
- BitPeer integration (TBD): design an adapter to use BitPeer as a P2P overlay for signaling/peer discovery where applicable.
- Push: Web Push to notify offline recipients; user consent driven.
- Privacy/consent: clear prompts before initiating calls; rate‑limit unsolicited pings.

## Integrations
- NADOO‑IT (backend/services/bots): invitation flows, QR generation, and bridges (Telegram/WhatsApp) into PWA chat.
- NADOO‑Launchpad: reuse functions/classes (e.g., voice‑to‑text, codegen, testing). Consider a generator for new card templates/components.
- FIDO2/WebAuthn: owners authenticate to edit/manage their card; visitors remain passwordless/anonymous.

## MVP Roadmap
1) PWA shell
   - `manifest.json`, service worker (Workbox), HTTPS, install prompt UI.
   - Card page: avatar, name, role, location; QR + share button; vCard export.
2) Contact & social actions
   - Buttons for call / message / email / WhatsApp / Telegram; social grid; theming.
3) WebRTC 1:1 call + chat
    - Simple signaling (NADOO‑IT), STUN; add TURN for reliability; text chat via data channel.
4) Scheduling & calendar
     - Slot picker UI (timezone-aware), merged free/busy, buffers, working hours.
     - Providers Phase A: Google + ICS; confirmations with `.ics`; reschedule/cancel links.
5) Reminders & follow‑ups
     - Topic + due date/presets, notes; Web Push/email (and Telegram) notifications; deep link to card.
     - Optional "convert to appointment" flow and meeting link generation (NADOO-IT preferred; P2P fallback).
6) Notifications
     - Web Push (VAPID) for missed calls/messages; reminder alerts; user settings to opt‑in.
7) Intl & customization
     - i18n, per‑card themes, analytics with privacy controls.

## Technical Notes
- Service worker and WebRTC require HTTPS; use real domain (nadooit.de and subdomains) or localhost for dev.
- Domains: primary `nadooit.de`; code portal `go.nadooit.de`.
- STUN for dev (e.g., Google public STUN); use NADOO‑IT STUN/TURN in prod.
- Store only what’s necessary (privacy by default); client‑side encryption where possible.
- Accessibility: keyboard navigation, color contrast, captions for video.

## Open Questions
- BitPeer API/capabilities: confirm features and best place in the stack (signaling vs overlay).
- Rate‑limiting and abuse prevention for unsolicited calls.
- Hosting model (per‑card subdomain vs path‑based) and multi‑tenant theming.
