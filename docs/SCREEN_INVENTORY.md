# Doc-Find: Screen Inventory & UI Specification

This document provides a comprehensive inventory of all screens, UI states, copy (English & French), animations, and design system tokens extracted directly from the visual source of truth wireframes:
- Mobile App: `design/doc-find.html` (390×844 viewport)
- Admin Dashboard: `design/doc-find-admin.html` (1280×800 desktop, 390×844 responsive mobile)

All reference screenshots are located in `design/screenshots/`.

---

## 1. Design System Tokens

### 1.1 Color Tokens

| Token Name | Light Value | Dark Value | Purpose |
|---|---|---|---|
| `AppColors.background` | `#E4EBE6` | `#070D0A` | Scaffold and page background |
| `AppColors.surface` | `#FFFFFF` | `#14201A` | Cards, sheets, dialog surfaces |
| `AppColors.ink` | `#10231A` | `#E8F0EB` | Primary typography & icons |
| `AppColors.muted` | `#5C6B63` | `#93A59A` | Secondary typography & subtle hints |
| `AppColors.primary` | `#0E6B47` | `#3DBF86` | Brand primary green, buttons, active icons |
| `AppColors.greenTint` | `#DCEDE3` | `#1B3A2C` | Soft green badges, selection highlights |
| `AppColors.onPrimary` | `#FFFFFF` | `#06140D` | Foreground text on primary buttons |
| `AppColors.sun` | `#F5B700` | `#F5B700` | Focus rings, scanlines, accent rings |
| `AppColors.red` | `#C9382C` | `#E24C40` | Destructive actions, unread indicators, errors |
| `AppColors.line` | `#D5DED8` | `#26372E` | Dividers, card borders, form outlines |

#### Document-Type Color Tags
- **ID Card (`id`)**: `#2E7D5B`
- **Passport (`pass`)**: `#274C9B`
- **Birth Certificate (`birth`)**: `#B4741C`
- **Driver's Licence (`lic`)**: `#8A3AA3`
- **Other Document (`other`)**: `#5C6B63`

### 1.2 Typography Tokens
- **Headings**: `Bricolage Grotesque`
  - Weights: SemiBold (600), ExtraBold (800)
  - Letter spacing: `-0.02em` (slightly negative)
- **Body & Captions**: `Figtree`
  - Weights: Regular (400), Medium (500), SemiBold (600)
  - Line height: `1.45`
- **System Settings Support**: Dynamic font scaling up to 200% without overflow or text clipping.

### 1.3 Shape & Elevation Tokens
- **Cards**: `BorderRadius.circular(18)`
- **Buttons**: `BorderRadius.circular(14)`
- **Chips**: `BorderRadius.circular(999)` (Pill / fully rounded)
- **Bottom Sheets**: `BorderRadius.vertical(top: Radius.circular(26))`
- **Input Fields**: `BorderRadius.circular(14)`
- **Touch Targets**: Minimum `48×48 dp` for interactive elements
- **Elevation / Shadows**: Soft layered shadows (`0 8px 24px rgba(16, 35, 26, 0.06)`)

### 1.4 Motion & Animation Tokens
- **Screen push**: 380 ms `cubic-bezier(0.2, 0.8, 0.2, 1)`
- **Sheet open/close**: 400 ms `ease-out`
- **List items entrance**: Staggered entrance 50 ms apart, duration 400 ms
- **Chip select**: Scale transition `1.04`
- **Switch toggle**: Spring thumb animation
- **Success checkmark**: Animated stroke draw over ~500 ms
- **Reduce-motion setting**: Respects OS accessibility preference and disables decorative springs/sweeps

---

## 2. Mobile App Screen Inventory (Phase 1)

### Screen 1: Splash Screen
- **Screenshot**: `design/screenshots/mobile_01_splash.png`
- **States**: Initial drop-in → Magnifier sweep → Redaction draw → Title fade-in → Exit fade/scale
- **Timing**: ~3.3 seconds total, tap anywhere to skip
- **Visuals**: Primary green background (`#0E6B47`), white document card dropping with rotation spring, yellow circular magnifying lens (`#F5B700`), sequential black redaction bars drawn across fields, bold "Doc-Find" title and tagline.
- **Strings**:
  - EN: "Doc-Find", "Connecting found official documents with their owners in Cameroon."
  - FR: "Doc-Find", "Connecter les documents officiels trouvés à leurs propriétaires au Cameroun."

---

### Screen 2: Onboarding (3 Slides)
- **Screenshots**:
  - Slide 1: `design/screenshots/mobile_02_onboarding_slide1.png`
  - Slide 2: `design/screenshots/mobile_03_onboarding_slide2.png`
  - Slide 3: `design/screenshots/mobile_04_onboarding_slide3.png`
- **States**: Slide 1, Slide 2, Slide 3, Swipeable with animated dot indicators
- **Controls**: "Skip" button (top-right), "Next" button (bottom, becomes "Get started" on slide 3)
- **Strings**:
  - Slide 1 Title (EN): "Lost an ID or passport?"
    Slide 1 Body (EN): "Search Cameroon-wide in seconds. If it's been found, your document is waiting safely."
    Slide 1 Title (FR): "Perdu une pièce d'identité ?"
    Slide 1 Body (FR): "Recherchez dans tout le Cameroun en quelques secondes."
  - Slide 2 Title (EN): "Found one? Report it fast."
    Slide 2 Body (EN): "Snap a picture. We automatically redact personal info before anything goes public."
    Slide 2 Title (FR): "Trouvé un document ? Signalez-le."
    Slide 2 Body (FR): "Prenez une photo. Nous masquons les données personnelles avant publication."
  - Slide 3 Title (EN): "A safe handoff, every time."
    Slide 3 Body (EN): "Prove it's yours with one question. We coordinate the handoff—finders and owners never meet unverified."
    Slide 3 Title (FR): "Une remise sécurisée, toujours."
    Slide 3 Body (FR): "Prouvez votre identité. Notre équipe coordonne la restitution."

---

### Screen 3: Authentication (Login / Register)
- **Screenshots**:
  - Login Tab: `design/screenshots/mobile_05_auth_login.png`
  - Register Tab: `design/screenshots/mobile_06_auth_register.png`
  - Inline Error: `design/screenshots/mobile_07_auth_error.png`
- **States**: Login mode, Register mode, Loading submission, Inline error (shake animation)
- **Controls**:
  - Green header band with logo and title
  - Segmented control: `Log in` | `Create account`
  - Login inputs: Email or phone (`you@email.com or 6XXXXXXXX`), Password (with Show/Hide eye button)
  - Quick demo credentials fill-in link (`demo@docfind.cm · demo1234`)
  - Register inputs: Full name, Phone number (+237), Email, Password (≥ 6 characters, recommend ≥ 8)
  - Consent Checkbox (Strict opt-in, Law 2024/017):
    - EN: "I agree that Doc-Find stores my name, phone and email to run this service (Law No. 2024/017). I can withdraw anytime."
    - FR: "J'accepte que Doc-Find enregistre mes données pour ce service (Loi n° 2024/017). Retrait possible à tout moment."

---

### Screen 4: Main App Shell & Bottom Navigation
- **Top App Bar**:
  - Brand Logo + "Doc-Find" title
  - Notification Bell icon button (with unread red badge) → routes to Messages
  - User Avatar with initials and customizable color swatch → routes to Profile & Settings
- **Bottom Navigation Bar**:
  - 4 tabs: **Search** (Magnifier icon), **Report** (Plus/Camera icon), **Messages** (Chat bubble + badge), **Alerts** (Bell icon)
  - Active indicator sliding bar across top edge of the selected tab item

---

### Screen 5: Search & Document Feed (Home Tab)
- **Screenshots**:
  - Default view: `design/screenshots/mobile_08_search_default.png`
  - Filtered by type: `design/screenshots/mobile_09_search_filter_id.png`
  - Empty state: `design/screenshots/mobile_10_search_empty.png`
  - Dark mode: `design/screenshots/mobile_23_dark_mode.png`
  - French language: `design/screenshots/mobile_24_french_locale.png`
- **Controls & Filters**:
  - Title: "Find a lost document" / "Trouver un document perdu"
  - Search input: "Town or name, e.g. Bafoussam" (debounced 300 ms)
  - Filter Chips (horizontally scrollable or wrapped): `All`, `ID card`, `Passport`, `Birth certificate`, `Driver's licence`, `Other`
  - Dropdown 1 (Town): All towns, Douala, Yaoundé, Bafoussam, Bamenda, Garoua, Buea
  - Dropdown 2 (Date): Any date, Last 7 days, Last 30 days
  - Result count text: "8 documents found"
  - Action button: "Alert me for this search" (saves alert + triggers toast)
- **ResultCard Elements**:
  - Redacted thumbnail with diagonal/blur styling and document type stamp
  - Colored Document Type tag (`ID card`, `Passport`, etc.)
  - Redacted Partial Name (e.g. `K•••• N••••••`)
  - Subtitle: `Town · When` (e.g. `Douala · Today`, `Yaoundé · 2 days ago`)
  - Found spot excerpt
- **Empty State**:
  - Heading: "No match yet" / "Aucun résultat"
  - Description: "Try another town or date, or tap 'Alert me for this search'. We'll tell you when one appears."

---

### Screen 6: Listing Detail View (Push Transition)
- **Screenshot**: `design/screenshots/mobile_11_listing_detail.png`
- **States**: Full screen push transition, Back navigation button in header
- **Content**:
  - Hero Redacted Illustration: Large simulated ID/passport card, blurred photo portrait, black redaction bars across sensitive numbers, official document stamp
  - Document Type badge + Partial Name headline (e.g. `K•••• N••••••`)
  - Metadata Rows:
    - Found in: `Douala`
    - Place: `Akwa, near Rond-point Deido`
    - Date: `Today`
    - Finder note: `Found on a taxi seat. Held by finder.`
    - Custody status: `Held safely by our team` (Green shield badge)
  - Privacy Notice (Cameroon Law No. 2024/017):
    - EN: "Personal numbers and photo are redacted to protect the owner's privacy. To claim this document, you must answer a verification question."
    - FR: "Les numéros personnels et la photo sont masqués pour protéger la vie privée. Pour réclamer ce document, répondez à la question de vérification."
  - Sticky CTA: "This is my document" (`#0E6B47` primary button)

---

### Screen 7: Claim Bottom Sheet
- **Screenshot**: `design/screenshots/mobile_12_claim_sheet.png`
- **States**: Modal bottom sheet (top radius 26, scrim backdrop), keyboard-aware
- **Controls**:
  - Grab handle
  - Title: "Prove it's yours" / "Prouvez votre identité"
  - Subtitle: "Answer the verification question below so our team can verify ownership."
  - Type-specific Question:
    - ID Card: *"Which town issued your card?"*
    - Passport: *"What is your date of birth?"*
    - Birth Certificate: *"What is your mother's first name?"*
    - Driver's Licence / Other: *"Which date is printed as the issue date?"*
  - Answer Input Field (`#ans`) with placeholder
  - Optional Attachment: "Add photo of matching ID (optional)"
  - Submit Button: Disabled until answer length ≥ 2 characters
  - Submit Action: Closes sheet, creates/swaps to chat thread, displays welcome confirmation toast, routes to Messages

---

### Screen 8: Report Flow (3-Step Modal + Success)
- **Screenshots**:
  - Step 1 Viewfinder: `design/screenshots/mobile_13_report_step1_viewfinder.png`
  - Step 1 Preview: `design/screenshots/mobile_14_report_step1_preview.png`
  - Step 2 Details: `design/screenshots/mobile_15_report_step2_details.png`
  - Step 3 Consents: `design/screenshots/mobile_16_report_step3_consent.png`
  - Success State: `design/screenshots/mobile_17_report_success.png`
- **Progress Indicator**: 3 step bars at top
- **Step 1: Document Capture**:
  - Viewfinder with yellow corner brackets (`#F5B700`), animated scanning laser line
  - Guidance text: "Align the document inside the frame"
  - Camera shutter button with flash animation
  - After snap: Live preview showing simulated server-side redactions applied immediately
  - Retake button / Proceed to Next
- **Step 2: Document Details**:
  - Document type selector chips
  - Town dropdown selection
  - Exact place input ("e.g. Taxi stand Akwa, near bakery")
  - Optional finder note
- **Step 3: Verification & Legal Consents**:
  - Two strict opt-in checkboxes (Law No. 2024/017):
    1. Consent to process document photo & location for identification
    2. Consent to store finder phone number strictly for handoff facilitation
  - Legal disclaimer note
  - "Submit for review" button (disabled until both checkboxes checked)
- **Step 4: Success Screen**:
  - Animated expanding green checkmark circle
  - "Thank you for helping your community!"
  - Animated Status Timeline:
    1. `Report received` (Complete)
    2. `Team review & redaction` (In progress)
    3. `Published for search`
    4. `Secure handoff with owner`
  - Item listed under "Your recent reports" with `In review` badge

---

### Screen 9: Messages & Chat
- **Screenshots**:
  - Thread list: `design/screenshots/mobile_18_messages_threads.png`
  - Chat view: `design/screenshots/mobile_19_messages_chat.png`
- **Thread List**:
  - Thread items with "DF" circular avatar, title ("Doc-Find team"), snippet of last message, timestamp
- **Chat Screen**:
  - Header with team avatar, "Doc-Find team", and subtitle "Official Support"
  - Chat bubbles:
    - User message: Primary green (`#0E6B47`), white text, aligned right
    - Team message: Surface white (`#FFFFFF`), ink text, border, aligned left
  - Typing indicator: Three bouncing dots animation
  - Bottom input bar with text field and send button (mock reply received in ~1.4s)

---

### Screen 10: Alerts Tab
- **Screenshot**: `design/screenshots/mobile_20_alerts.png`
- **Content**:
  - Title: "Saved search alerts"
  - Description: "Receive immediate Push and SMS notifications when a matching document is reported."
  - Cards for active alerts:
    - e.g. "ID card · Douala", toggle switch active
    - e.g. "Passport · Any town", toggle switch inactive

---

### Screen 11: Profile & Settings
- **Screenshot**: `design/screenshots/mobile_21_profile_settings.png`
- **Content**:
  - Avatar color picker with 5 selectable swatches
  - Editable Profile form: Full name, Phone number, Email address
  - Language selection: Instant switch between `English` and `Français`
  - Appearance: `System`, `Light`, `Dark`
  - Default Town dropdown
  - Notification toggles: Push notifications, SMS notifications, Email summaries
  - Privacy & Security:
    - Change password (bottom sheet)
    - Download my personal data archive (GDPR / Law 2024/017 export)
    - Delete account (confirmation bottom sheet, destructive styling)
  - Log out button

---

### Screen 12: Global Toast
- **Screenshot**: `design/screenshots/mobile_22_toast.png`
- **Behavior**: Top-floating capsule toast, auto-dismisses after ~2.6 seconds, accessible announcement for screen readers.

---

## 3. Admin Dashboard Screen Inventory (Phase 2)

- `admin_01_overview.png`: Admin Overview with 4 KPI counters, submitted vs returned bar chart, recent activities, "Needs attention" shortcut.
- `admin_02_review_queue.png`: Review queue master-detail with locked original, public preview, redaction controls.
- `admin_03_review_queue_revealed.png`: Review queue with original revealed (explicit audit-logged action).
- `admin_04_claims.png`: Claims verification master-detail with side-by-side proof check (document vs claimant answer), fraud risk indicators, quick replies.
- `admin_05_claims_handoff_sheet.png`: Handoff coordination bottom sheet (pickup point + appointment time).
- `admin_06_listings.png`: Listings data table with filter chips, search, and status lifecycle actions (Mark recovered, Archive, Restore).
- `admin_07_listings_bulk_sheet.png`: Partner bulk import sheet (CSV upload for police stations / prefectures).
- `admin_08_fraud_reports.png`: Fraud reports card list with Suspend User and Dismiss actions.
- `admin_09_audit_log.png`: Tamper-evident admin audit log with sensitive event filters.
- `admin_10_settings.png`: Moderation rules, privacy timers (auto-archive 14/30/60 days, image retention 7/30/90 days).
- `admin_11_responsive_mobile.png`: Admin layout responding cleanly to mobile viewport (<820px).

---

## 4. Mock Data Specification

### 4.1 Seed Listings (8 Items)
```json
[
  {
    "id": 1,
    "type": "id",
    "name": "K•••• N••••••",
    "town": "Douala",
    "spot": "Akwa, near Rond-point Deido",
    "days_ago": 0,
    "note": "Found on a taxi seat. Held by finder.",
    "question": "Which town issued your card?"
  },
  {
    "id": 2,
    "type": "pass",
    "name": "M•••• T••••",
    "town": "Yaoundé",
    "spot": "Mvan bus park",
    "days_ago": 2,
    "note": "Passport cover is dark blue. Issued 2022.",
    "question": "What is your date of birth?"
  },
  {
    "id": 3,
    "type": "birth",
    "name": "E•••• A••••",
    "town": "Bafoussam",
    "spot": "Marché A",
    "days_ago": 5,
    "note": "Folded in a plastic sleeve.",
    "question": "What is your mother's first name?"
  },
  {
    "id": 4,
    "type": "lic",
    "name": "F•••• B••••",
    "town": "Douala",
    "spot": "Bonabéri ferry quay",
    "days_ago": 9,
    "note": "Category B licence.",
    "question": "Which date is printed as the issue date?"
  },
  {
    "id": 5,
    "type": "id",
    "name": "S•••• M••••",
    "town": "Buea",
    "spot": "University of Buea gate",
    "days_ago": 12,
    "note": "Card is slightly bent.",
    "question": "Which town issued your card?"
  },
  {
    "id": 6,
    "type": "id",
    "name": "A•••• N••••",
    "town": "Garoua",
    "spot": "Grand Marché",
    "days_ago": 3,
    "note": "Found near the pharmacy stalls.",
    "question": "Which town issued your card?"
  },
  {
    "id": 7,
    "type": "birth",
    "name": "J•••• T••••",
    "town": "Bamenda",
    "spot": "Commercial Avenue",
    "days_ago": 20,
    "note": "Photocopy certified, original attached.",
    "question": "What is your mother's first name?"
  },
  {
    "id": 8,
    "type": "other",
    "name": "Student card · P•••• L••••",
    "town": "Yaoundé",
    "spot": "Ngoa-Ekélé",
    "days_ago": 1,
    "note": "University student card.",
    "question": "Which date is printed as the issue date?"
  }
]
```

### 4.2 Seed Mock Account
- **Email**: `demo@docfind.cm`
- **Password**: `demo1234`
- **Full Name**: `K. N.`
- **Phone**: `+237 670 000 000`
- **Avatar Color**: `#0E6B47`

### 4.3 Validation Rules
- **Phone**: Exactly 9 digits starting with `6` after stripping spaces, `+`, and `237` country prefix.
- **Email**: Standard RFC 5322 regex validation.
- **Password**: Minimum 6 characters (UI recommends ≥ 8).
- **Full Name**: Minimum 2 characters.
- **Exact Place**: Minimum 3 characters.
- **Claim Answer**: Minimum 2 characters.
