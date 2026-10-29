# Doc-Find: Master Build Prompt
Frontend first, backend last. Paste or point your coding agent at this file. Keep it in the repo root.

## 0. How to use this file
- Work in phases, in order. Do not start a phase until the previous one meets its Definition of Done (DoD).
  1. Phase 1: Flutter mobile app (UI + local/mock data)
  2. Phase 2: Admin dashboard frontend (Vue 3, mock data)
  3. Phase 3: Backend (FastAPI + PostgreSQL) and wiring both frontends to it
  4. Phase 4: Hardening, QA, release
- The two HTML wireframes are the visual and behavioral source of truth: `doc-find.html` (mobile app) and `doc-find-admin.html` (admin). Open them in a browser, read their source, and treat every string, colour, timing and interaction as a requirement.
- Where this file says Improve, you may deviate from the wireframe to make it better, as long as you list the deviation in `docs/DEVIATIONS.md`.
- If something is ambiguous, make the most reasonable decision, write it in `docs/DECISIONS.md` (one line each), and continue. Ask only for blocking questions.

## 1. Role and ground rules
You are a senior software engineer (mobile + full stack). You write production-grade code that a small team can maintain.

Always:
- Plan before coding: first output a short plan and a file tree for the current phase, then implement in small, reviewable commits (Conventional Commits: `feat:`, `fix:`, `refactor:`, `test:`, `docs:`).
- Keep every function small and single-purpose. No dead code, no commented-out code, no magic numbers (use named constants/tokens).
- Write tests with the feature, not afterwards.
- Never put secrets in the repo. Use `.env` files and provide `.env.example`.
- After each milestone, run formatter, linter and tests, and report results.

## 2. Product context
Doc-Find connects people who find lost official documents (ID cards, passports, birth certificates, driver's licences, student cards) with the people who lost them, in Cameroon.

Flow: finder submits photo + place + date → admin reviews and redacts → a redacted listing is published → the owner searches, proves ownership, and talks to the Doc-Find team (never directly to the finder) → admin brokers the handoff → listing becomes Recovered and leaves public search.

Users: public (owners, finders) on the mobile app (Android-majority market, often low-end phones, patchy data); admins/moderators on a web dashboard.

Non-negotiable privacy rules (Cameroon Law No. 2024/017 on personal data protection):
1. The unredacted document image is never public. Redaction happens server-side. The client only ever receives the redacted version.
2. Consent is strict opt-in: no pre-ticked boxes, no bundled consent, one purpose per checkbox, withdrawable at any time.
3. Data minimisation: collect only what a screen needs.
4. Admins have no default access to originals. Every original view is explicit and audit-logged.
5. Breach detection and logging are built in from day one.
6. Finder and owner are never exposed to each other; the team brokers everything.

## 3. Locked decisions (from our discussion)
| Area | Decision |
|---|---|
| Mobile app | Flutter / Dart, one codebase (Android first, iOS second) |
| Admin dashboard | Vue 3 + Vite + TypeScript (Pinia, Vue Router, vue-i18n) |
| Backend | Python + FastAPI, SQLAlchemy 2 + Alembic |
| Database | PostgreSQL (via Supabase; SQL control and data-residency options) |
| Storage | Supabase Storage (S3-compatible): private bucket for originals, public/CDN bucket for redacted images |
| Push | Firebase Cloud Messaging (FCM) |
| Realtime | Supabase Realtime or WebSocket for chat; polling fallback |
| Auth | Email or phone + password, JWT access + rotating refresh token; Supabase Auth or own FastAPI auth (decide in Phase 3 and log it) |
| Languages | English and French everywhere, switchable at runtime |
| Android support | Must run on old Android (see section 6.1) |
| Location filtering | Simple lat/lng + town filter first; PostGIS later if needed |

Alternatives we considered and parked: Firebase as backend (kept only for FCM), Node/Express (not for this project), PostGIS (later).

## 4. Engineering principles (apply everywhere)
### Architecture
- SOLID, especially dependency inversion: UI depends on interfaces (repositories), never on concrete data sources.
- Feature-first clean architecture: `presentation → domain → data`. Domain has no Flutter or HTTP imports.
- Repository pattern with swappable data sources: Phase 1 uses `Mock*DataSource` (seeded with the wireframe's data); Phase 3 swaps in `Remote*DataSource` with no UI change.
- Unidirectional data flow, immutable models (`freezed`), explicit state classes (`loading` / `data` / `empty` / `error`). No business logic in widgets.
- Errors are values: use a `Result<T, Failure>` type (or `AsyncValue`), map every exception to a user-readable, localised message.

### Quality
- Strict lints (`flutter_lints` + `very_good_analysis` rules you can justify). Zero analyzer warnings.
- Test pyramid: many unit tests (domain, validators, repositories), widget tests for each screen state, golden tests for key screens, a few integration tests for critical flows.
- Accessibility is a requirement, not a polish step.

### Software ergonomics (UX engineering) rules
- Touch targets ≥ 48×48 dp; primary actions in the thumb zone (bottom).
- Feedback within 100 ms of any tap (ripple/animation); anything over 400 ms shows a skeleton or progress.
- Progressive disclosure: show only what the current step needs (the wireframe's 3-step report flow is the model).
- Error prevention before error messages: disable submit until valid, inline validation, clear hints.
- Consistency: one pattern per job (one bottom sheet style, one toast style, one empty-state style).
- Forgiving: confirm destructive actions, keep drafts, allow back-navigation without data loss.
- Recognition over recall: visible labels, no icon-only critical actions without a semantic label.
- Respect system settings: font scale up to 200%, reduce-motion, dark mode, language.
- Contrast WCAG AA minimum for text; never rely on colour alone for state.

## 5. Repository layout (monorepo)
```
doc-find/
├─ DOC-FIND_MASTER_PROMPT.md
├─ design/ # the two HTML wireframes + reference screenshots
│ ├─ doc-find.html
│ ├─ doc-find-admin.html
│ └─ screenshots/ # generated in Phase 1, step 1
├─ docs/ # DECISIONS.md, DEVIATIONS.md, ARCHITECTURE.md, API.md
├─ apps/
│ ├─ mobile/ # Flutter (Phase 1)
│ └─ admin/ # Vue 3 (Phase 2)
├─ services/
│ └─ api/ # FastAPI (Phase 3)
└─ .github/workflows/ # CI per app
```

---

# PHASE 1: Flutter mobile app

## 6. Goal
Recreate the wireframe in `design/doc-find.html` exactly (layout, copy, colours, spacing, motion, behaviour) as a native Flutter app, running on mock data, with a clean architecture ready for the real API.

### 6.1 Android compatibility (hard requirement)
- `minSdkVersion 21` (Android 5.0 Lollipop). `targetSdk` / `compileSdk` = latest stable.
- Enable `multiDexEnabled` and core library desugaring if any dependency needs it.
- Before adding any package, check its minimum Android API. If it needs more than 21, find an alternative or gate the feature with a graceful fallback. (Example to verify: recent `flutter_secure_storage` versions may require a higher minSdk.)
- Handle runtime permissions (camera, location, notifications) on API 23+ and install-time permissions below. Notification channels only on API 26+. Never crash if a permission is denied; show an explanation screen and a settings shortcut.
- Performance budget for low-end devices (2 GB RAM, API 21–26): cold start < 3 s, 60 fps lists, no jank on screen transitions. Avoid `BackdropFilter` and large blurs in scrolling lists; use `const` widgets, `RepaintBoundary` around heavy animations, `ListView.builder`, image caching and downscaling.
- Bundle fonts as assets (no runtime Google Fonts download; users are often offline).
- Ship as an Android App Bundle with ABI splits; target a small download size.
- Test matrix: API 21, API 23, API 26, API 30, latest. Use emulators plus at least one real low-end phone.
- Do not use Android 10+ only features (e.g. IMEI) in this app.

### 6.2 Tech stack (mobile)
Flutter stable, Dart 3, `flutter_riverpod` (state/DI), `go_router`, `freezed` + `json_serializable`, `dio` (networking, Phase 3), `shared_preferences` + a secure token store, `camera` or `image_picker` (verify minSdk), `geolocator` (verify minSdk), `firebase_messaging` (Phase 3), `flutter gen-l10n` with ARB files (`en`,`fr`), `mocktail`, `golden_toolkit` or built-in goldens. Animations: Flutter's own implicit/explicit animations; add `flutter_animate` only if it keeps the code simpler.

### 6.3 Folder structure (`apps/mobile/lib`)
```
lib/
├─ main.dart, app.dart
├─ core/
│ ├─ theme/ # tokens, ThemeData light/dark, typography
│ ├─ router/ # go_router config, guards (auth, intro-seen)
│ ├─ l10n/ # app_en.arb, app_fr.arb
│ ├─ widgets/ # DocCard, RedactedDoc, AppBar, BottomNav, Toast, Sheet, Chip, Switch, EmptyState, Skeleton
│ ├─ utils/ # validators, formatters, result.dart, debouncer
│ └─ constants/ # towns, document types, durations, spacing
├─ features/
│ ├─ splash/ onboarding/ auth/ search/ listing_detail/ claim/
│ ├─ report/ messages/ alerts/ settings/ profile/
│ │ └─ each: data/ (datasources, models, repo impl), domain/ (entities, repo interface, use cases), presentation/ (screens, widgets, controllers)
└─ shared/ # cross-feature entities (User, Listing, Thread, Alert)
```

### 6.4 Design system (extract exactly from the HTML, then tokenise)
Do not hard-code values in widgets. Create `AppColors`, `AppSpacing`, `AppRadius`, `AppText`, `AppMotion`.
- Colours (light): background `#E4EBE6`, surface `#FFFFFF`, ink `#10231A`, muted `#5C6B63`, primary green `#0E6B47`, green-tint `#DCEDE3`, sun `#F5B700`, red `#C9382C`, line `#D5DED8`, on-primary `#FFFFFF`.
- Colours (dark): background `#070D0A`, surface `#14201A`, ink `#E8F0EB`, muted `#93A59A`, primary `#3DBF86`, green-tint `#1B3A2C`, line `#26372E`, on-primary `#06140D`.
- Document-type colours: ID `#2E7D5B`, Passport `#274C9B`, Birth certificate `#B4741C`, Licence `#8A3AA3`, Other `#5C6B63`.
- Typography: headings Bricolage Grotesque (600/800, slightly negative letter-spacing), body Figtree (400/500/600). Respect system font scaling.
- Shape: cards radius 18, buttons radius 14, chips fully round, bottom sheets radius 26 top, phone-frame look is web-only (do not reproduce the device frame).
- Motion: screen push 380 ms `cubic-bezier(.2,.8,.2,1)`; sheet 400 ms; list items staggered entrance 50 ms apart, 400 ms; chip select scale 1.04; switch thumb spring; success checkmark draws over ~500 ms; reduce-motion setting disables non-essential animation.

### 6.5 Domain data (seed the mock data source with the wireframe's data)
- Document types: `id` (ID card), `pass` (Passport), `birth` (Birth certificate), `lic` (Driver's licence), `other`.
- Towns: Douala, Yaoundé, Bafoussam, Bamenda, Garoua, Buea (+ "Other" when reporting).
- Seed listings (8) exactly as in the wireframe: partial names like `K•••• N••••••`, town, spot, days ago, note.
- Proof-of-ownership question by type:
  - ID → "Which town issued your card?"
  - Passport → "What is your date of birth?"
  - Birth certificate → "What is your mother's first name?"
  - Other → "Which date is printed as the issue date?"
- Seed account for mock login: `demo@docfind.cm` / `demo1234` (mock data source only; remove when the real API lands).
- Validation rules (centralised in `core/utils/validators.dart`, unit-tested):
  - phone = 9 digits starting with 6 after stripping spaces, `+` and `237`
  - email = standard pattern
  - password ≥ 6 (Improve: recommend ≥ 8 and log it)
  - name ≥ 2 chars
  - exact place ≥ 3 chars
  - claim answer ≥ 2 chars.

### 6.6 Screens and behaviour (parity checklist)
Build each as its own feature with all states (loading, data, empty, error, offline).
1. **Splash** (~3.3 s, tap to skip). Green background. A document card drops in with a slight rotation (spring), a yellow magnifier lens sweeps across it, black redaction bars draw over the fields one after another, then "Doc-Find" and the tagline fade up. Then fade/scale out.
2. **Onboarding** (3 slides, shown once). Floating emoji/illustration "orb" with a slowly rotating dashed yellow ring; swipeable; animated dots; "Skip" top-right; button "Next" → "Get started". Slides: *Lost an ID or passport?*, *Found one? Report it fast.*, *A safe handoff, every time.* (copy from the HTML).
3. **Auth**. Green header band with logo, title ("Welcome back" / "Create your account"), animated segmented control Log in | Create account.
   - Login: email-or-phone + password with Show/Hide, inline error with a shake animation, demo hint (mock only).
   - Register: full name, phone (+237), email, password, unticked consent checkbox (Law 2024/017 wording), errors for each rule, duplicate account error.
   - On success the auth layer slides away and the app shell appears with a welcome toast.
4. **App shell**. Fixed top app bar: logo + "Doc-Find", bell (→ Messages, red dot when unread), avatar with initials (→ Profile and settings). Bottom navigation: Search, Report, Messages (unread badge), Alerts; animated active indicator at the top edge of the tab.
5. **Search**. Title "Find a lost document"; search field (town or name); document-type chips (All + 5 types, wrapped); town dropdown; date dropdown (Any / last 7 / last 30 days); result count + "Alert me for this search" (saves an alert + toast). Results are a vertically scrolling list (not paged) with staggered entrance and `ResultCard`: redacted document thumbnail, type tag, partial name, "town · when". Empty state with helpful text. Scroll resets to top when filters change. *Improve*: debounce text input (300 ms), pull-to-refresh, skeleton while loading, retain filters across app restarts.
6. **Listing detail** (push transition). Large redacted document illustration (blurred portrait, black bars, type stamp), type, partial name, rows: Found in / Place / Date / Note / Status ("Held safely by our team"), privacy note, sticky CTA "This is my document".
7. **Claim bottom sheet**. Title "Prove it's yours", the type-specific question, answer field, optional "Add photo" of own ID, submit disabled until the answer is valid. On submit: close, create/reuse the thread for that listing, toast, switch to Messages and open the chat.
8. **Report a found document** (full-screen flow, 3 steps + success). Step indicator bars filling in.
   - *Step 1*: camera viewfinder with yellow corner brackets and animated scan line, shutter button with flash effect, then a preview of the public (redacted) result.
   - *Step 2*: type chips, town select, exact place, optional note.
   - *Step 3*: two unticked consent items (photo + location; phone number for handoff), animated check boxes, law note, "Submit for review".
   - *Success*: ring with drawn checkmark, "Thank you", animated timeline (Report received → Team review → Posted with redaction → Handoff with the owner). The report then appears under "Your recent reports" with an *In review* tag.
   - *Improve*: save drafts, compress images before upload (target < 400 KB), handle camera permission denial, and let the user retake.
9. **Messages**. Thread list (avatar "DF", title, last message). Chat page: header with ellipsised title, "Doc-Find team", bubbles (me = primary, team = surface), typing indicator (three bouncing dots), vertically scrollable, input bar. Mock replies after ~1.4 s. New claim threads start with the claimant's message + an automatic team reply.
10. **Alerts**. List of saved searches with a switch each ("Push + SMS when posted" / "Paused"). New alerts created from Search.
11. **Profile and settings** (scrollable page). Avatar with colour choice (5 swatches); edit name / phone / email with validation and uniqueness; Language (English / Français, applies instantly app-wide); Appearance (System / Light / Dark); Default town; Notifications switches (push, SMS, email receipts); Privacy and security: change password (sheet), download my data, delete account (confirm sheet, destructive style); Log out.
12. **Global**: toast component (top, auto-dismiss ~2.6 s), consistent bottom sheet, haptic feedback on key actions (guard for devices without a vibrator).

### 6.7 Internationalisation
Use ARB files for all strings (the wireframe used a runtime translation hack, do not copy that). Provide complete French translations (take them from the HTML's dictionary and complete the rest). Plurals and dates through `intl`. Language persisted and applied without restart. No string concatenation for sentences.

### 6.8 Accessibility checklist
Semantic labels on every icon button and image; logical focus order; TalkBack tested on the three main flows; text scale 200% without clipping (layouts must flex, not use fixed heights; fix the wireframe's fixed-height assumptions); minimum contrast AA; announcements for toasts and errors; reduce-motion honoured.

### 6.9 Deliverables and order of work
1. Render both HTML files headless (e.g. Chrome at 390×844) and save one screenshot per screen/state into `design/screenshots/`. Write an inventory (`docs/SCREEN_INVENTORY.md`) of every screen, string, state and animation.
2. Project bootstrap: lints, CI (analyze + test + build apk), theme tokens, fonts, l10n skeleton, router, `Result` type.
3. Core widgets (`RedactedDoc`, `DocCard`, toast, sheet, chips, switches, nav) with golden tests.
4. Features in this order: splash → onboarding → auth → shell → search → detail → claim → messages → report → alerts → settings.
5. Mock data sources + repository interfaces for every feature; seed data.
6. Compatibility pass on API 21/23/26 emulators; performance profiling; fix jank.
7. Accessibility and i18n pass.
8. Golden/pixel comparison against the reference screenshots; document every deviation.

### 6.10 Definition of Done (Phase 1)
- All 12 screens and flows behave like the wireframe, in English and French, light and dark.
- `flutter analyze` clean; unit + widget tests ≥ 80% on domain/presentation logic; goldens for key screens.
- Runs smoothly on API 21 and API 35 emulators; no crash when permissions are denied.
- No hard-coded colours, strings or magic numbers in widgets.
- `docs/ARCHITECTURE.md`, `DECISIONS.md`, `DEVIATIONS.md` written.
- Swapping a mock data source for a remote one needs changes only in the `data/` layer and DI.

---

# PHASE 2: Admin dashboard frontend (Vue 3)

## 7. Goal
Recreate `design/doc-find-admin.html` as a responsive Vue 3 + TypeScript app on mock data, same architecture discipline as Phase 1.

Stack: Vue 3 (Composition API, `<script setup>`), Vite, TypeScript strict, Pinia, Vue Router (history mode), `vue-i18n` (en/fr), Tailwind CSS using the same tokens as the wireframe (admin: bg `#EDF1EE`, sidebar `#0B2A1E`, same greens/sun/red), Vitest + Vue Test Utils, Playwright for a few end-to-end flows. Charts: simple inline SVG or a tiny library; no heavy dependencies.

Structure: `src/{app,router,stores,api (interfaces + mock + http),components,features/{overview,review-queue,claims,listings,fraud,audit,settings},composables,i18n,styles}`. API layer behind interfaces so mocks are swappable.

### Views and behaviour (parity checklist)
1. Shell: sidebar with counters (Review queue, Claims, Fraud reports), top bar with view title and search, admin chip. Under 820 px the sidebar becomes a bottom bar; master-detail stacks with a "Back" link.
2. Overview: 4 KPI cards with count-up animation, weekly bar chart (submitted vs returned) with growing bars, recent activity, "Needs attention" shortcut.
3. Review queue (master-detail): list with quality pill; detail shows Original (locked until "Reveal original", reveal is audit-logged) next to a live public preview; redaction controls: partial name, hide ID number, hide DOB, hide address, blur portrait + strength slider; finder and consent card; actions Approve and publish (disabled without photo + location consent), Ask for a better photo, Reject (reason sheet). Items animate out; toasts confirm.
4. Claims (master-detail): public listing, proof comparison (document says vs claimant answered, ✓/✗), risk pill and signals, conversation with quick replies, actions: Verify and arrange handoff (point + time sheet → message + SMS), Request more proof, Reject and flag (adds fraud report), Mark as handed over (listing becomes Recovered).
5. Listings: status chips, text filter, table (Document, Town, Online, Status, Views, Claims, actions: Mark recovered / Archive / Restore), auto-archive banner, Bulk post (CSV) sheet with progress that adds items to the review queue.
6. Fraud reports: cards with Suspend user / Dismiss.
7. Audit log: every admin action; "Show sensitive only" filter; reveal-original events flagged.
8. Settings: moderation toggles, privacy toggles, auto-archive (14/30/60), original-photo retention (7/30/90). Every change is audit-logged.

Improve: keyboard shortcuts in the review queue (A approve, R reject, ↑/↓ move), unsaved-change guards on redaction, bulk select, table sorting and server-style pagination, proper roles (Admin, Moderator, Read-only) with route guards, empty/error/loading states, a11y (focus management in sheets, ARIA for switches and tables).

Important: in the wireframe the redaction preview is drawn in the browser. In the real system the server produces the redacted image; the dashboard only sends the redaction parameters (which fields, blur strength, optional crop boxes) and displays the server's preview.

DoD (Phase 2): all views at parity, responsive from 360 px to 1920 px, en/fr, light/dark, typed API interfaces, ≥ 80% store/composable test coverage, Playwright covers review→approve and claim→handoff flows, lint/type-check clean.

---

# PHASE 3: Backends

## 8. Goal
One FastAPI service that serves both frontends. Replace mock data sources with real ones without touching UI code.

### 8.1 Structure (`services/api`)
```
app/
├─ main.py, config.py (pydantic-settings), deps.py
├─ core/ # security (JWT, hashing), logging, errors, rate limiting, audit
├─ domain/ # entities, enums, services (pure Python)
├─ db/ # models (SQLAlchemy 2), session, migrations (Alembic)
├─ repositories/
├─ services/ # redaction, storage, notifications (FCM), sms, messaging
├─ api/v1/ # routers: auth, users, listings, submissions, claims, messages, alerts, admin, audit, settings
└─ tests/ # pytest, httpx, factory-boy, testcontainers or a test DB
```

### 8.2 Data model (minimum)
`users` (role: user | moderator | admin, status, locale, avatar_color), `consents` (user, purpose, granted_at, withdrawn_at, text_version), `submissions` (finder, type, town, spot, found_at, note, original_path (private), quality, status: pending | approved | rejected), `listings` (submission, redacted_path, redaction_params, partial_name, status: live | recovered | archived, published_at, views), `claims` (listing, claimant, question, expected_hash, answer, id_photo_path, risk, status, signals), `messages` (thread/claim, sender_role, body, created_at), `alerts` (user, doc_type, town, enabled), `devices` (user, fcm_token, platform), `fraud_reports`, `audit_log` (actor, action, target, sensitive, ip, at), `settings`. Store expected proof answers hashed/normalised and compare server-side; the client never receives them.

### 8.3 API surface (REST, `/api/v1`, OpenAPI documented)
- Auth: register, login, refresh, logout, change password, delete account, data export.
- Public/user: `GET /listings` (filters: type, town, date range, text; cursor pagination), `GET /listings/{id}`, `POST /submissions` (multipart image + metadata + consents), `GET /me/submissions`, `POST /listings/{id}/claims`, `GET/POST /threads/{id}/messages`, `CRUD /alerts`, `PATCH /me` (profile + preferences), `POST /devices`.
- Admin: review queue (`GET /admin/submissions`, `GET /admin/submissions/{id}/original` → logged, `POST /admin/submissions/{id}/redaction-preview`, `POST …/approve`, `…/reject`, `…/request-retake`), claims (list, verify, request-more-proof, reject, handoff, mark-handed-over), listings (bulk CSV, status changes), fraud reports, audit log, settings, stats for the overview.

### 8.4 Key services
- Redaction service: Pillow (and optionally OCR later) applies blur/crop/mask boxes to produce the public image; strips EXIF/GPS; the original goes to a private bucket with signed, short-lived URLs only for logged admin views; scheduled deletion of originals after recovery (retention setting).
- Search: SQL filters + trigram/ILIKE for text; indexes on (status, type, town, published_at).
- Notifications: saved-search matcher runs on publish → FCM push, SMS fallback through a pluggable provider interface (choose a Cameroon-friendly provider in Phase 3 and log it).
- Messaging: claimant ↔ team only; finder identity is never exposed in any response schema.
- Abuse protection: rate limits per IP/phone/user (login, claims, submissions), claim-attempt caps per listing, duplicate-account and repeated-claim signals feeding the risk score.
- Security: Argon2/bcrypt hashing, short-lived access tokens, refresh rotation, strict CORS, input validation (Pydantic), upload type/size checks and image re-encoding, row-level security if using Supabase, secrets via environment, dependency scanning.
- Compliance: consent records versioned; export and delete endpoints; breach/anomaly logging with an alert hook (notify the Authority "without undue delay"); cross-border hosting decision documented in `docs/DECISIONS.md` (re-check Law 2024/017 implementing decree before launch).

### 8.5 Wiring
Mobile: implement `Remote*DataSource` with `dio` (interceptors: auth, refresh, retry with backoff, offline queue for submissions and messages), FCM registration, secure token storage, localised error mapping. Admin: implement the `http` API layer, replacing mocks, plus role guards. Contract tests against the OpenAPI schema; generate typed clients where practical.

DoD (Phase 3): every endpoint documented and tested (≥ 85% on services), Alembic migrations reproducible, seed script recreates the wireframe data, Docker Compose for local dev (API + Postgres), both frontends work end-to-end against the API on a staging deployment, redacted images are the only images any public endpoint can return.

---

# PHASE 4: Hardening and release
- Load test search and submission endpoints; set DB indexes from real query plans.
- Security review (OWASP MASVS for the app, OWASP ASVS for the API), penetration checklist, privacy impact assessment.
- Observability: structured logs, error tracking, uptime checks, audit-log retention policy.
- Release: Play Store listing (privacy policy, data-safety form with only the permissions used: camera, precise location when reporting, notifications), staged rollout; CI/CD for all three apps; backups and restore drill.
- Post-launch backlog: SMS-based flows for low connectivity, partner institution portal, iOS polish, optional ML document-matching.

---

# 9. Working agreement for the agent
1. Read this whole file and both HTML files.
2. Start Phase 1, step 1: generate screenshots and `docs/SCREEN_INVENTORY.md`, then show me the plan and file tree for step 2 before writing app code.
3. After each step, report: what was built, tests run and results, deviations, and the next step.
4. Do not start Phase 2 until I confirm Phase 1's Definition of Done.
5. Prefer boring, proven solutions. Explain trade-offs in one or two lines when you choose between options.

**First message to send:**
Read `DOC-FIND_MASTER_PROMPT.md` and the two HTML files in `design/`. Begin Phase 1, step 1 (screenshots and screen inventory), then propose the project bootstrap plan and the folder tree. Do not write feature code until I approve the plan.
