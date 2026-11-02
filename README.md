# Doc-Find · Cameroon Lost & Found Official Documents Platform

[![Mobile CI](https://github.com/docfind/docfind/actions/workflows/mobile.yml/badge.svg)](.github/workflows/mobile.yml)
[![Admin CI](https://github.com/docfind/docfind/actions/workflows/admin.yml/badge.svg)](.github/workflows/admin.yml)
[![Backend CI](https://github.com/docfind/docfind/actions/workflows/api.yml/badge.svg)](.github/workflows/api.yml)

**Doc-Find** is a national lost-and-found platform tailored specifically for Cameroon, securely reconnecting citizens who have lost vital official documents (National ID Cards / CNI, Passports, Birth Certificates, Driver's Licences, Student IDs) with finders and verified local collection hubs.

Engineered under strict compliance with **Cameroon Law No. 2024/017 on the Protection of Personal Data**, Doc-Find guarantees that personal identity data is never exposed publicly without redaction, and access to unredacted records is traceable through tamper-evident audit logs.

---

## 🏛️ System Architecture

Doc-Find is built as a production-grade monorepo organized into three primary tiers:

```
Doc_Find/
├── apps/
│   ├── mobile/         # Flutter Mobile Application (iOS & Android)
│   │                   # Clean Architecture, Riverpod, Offline-first, Bilingual (EN/FR)
│   └── admin/          # Moderation & Fraud Investigation Web Dashboard
│                       # Vue 3, TypeScript, Vite, Tailwind CSS, Pinia, Bilingual (EN/FR)
├── services/
│   └── api/            # Backend REST API Service
│                       # FastAPI, Python 3.12, SQLAlchemy 2.0, Pydantic v2, SQLite/PostgreSQL
├── design/             # Visual Source-of-Truth Wireframes & Screenshots
│   ├── doc-find.html   # Mobile design reference
│   ├── doc-find-admin.html # Admin dashboard reference
│   └── screenshots/    # Headless browser visual reference captures (35 states)
├── docs/               # Technical Specifications & Decision Logs
│   ├── DECISIONS.md    # Architecture & Engineering Decision Records
│   ├── DEVIATIONS.md   # Intentional Wireframe Enhancements Log
│   └── SCREEN_INVENTORY.md # Exhaustive screen, UI state, and API endpoint specifications
└── .github/workflows/  # CI/CD Workflows for Mobile, Admin, and API
```

---

## 🔒 Cameroon Law No. 2024/017 Privacy & Compliance

Every component of Doc-Find enforces personal data protection by design:

1. **Mandatory Explicit Dual Consents**:
   - Finder photo & location processing consent (unchecked by default).
   - Finder contact coordination consent (unchecked by default).
   - Registrations and submissions lacking affirmative consent are rejected at both client and API levels.
2. **Public Redaction by Default**:
   - National identity numbers, dates of birth, parents' names, and finder phone numbers are stripped from all public endpoints and search feeds.
   - Public images display simulated or applied secure redaction blocks.
3. **Frosted-Glass Admin Reveal & Audit Trail**:
   - Inside the Admin Review Queue, original unredacted documents remain locked behind frosted glass (`Original is hidden · Viewing is logged`).
   - Unlocking an unredacted document dispatches an immutable audit event flagged as `Sensitive` (`s: 1`, `is_sensitive=True`).
4. **90-Day Auto-Retention Policy**:
   - Resolved and unverified listings transition according to statutory retention schedules.

---

## 🚀 Quick Start & Local Development

### Prerequisites
- **Flutter SDK**: `^3.22.0` (Dart `^3.8.0`)
- **Node.js**: `^20.0.0` or `^22.0.0` with `npm`
- **Python**: `^3.12.0` with `pip`

---

### 1. Backend REST API (`services/api`)

The backend is built with FastAPI, SQLAlchemy 2.0, and Pydantic v2.

```bash
cd services/api

# Create & activate virtual environment (Windows PowerShell)
python -m venv .venv
.\.venv\Scripts\Activate.ps1

# Install dependencies
pip install -r requirements.txt
pip install pytest pytest-asyncio pytest-cov httpx

# Run the development server with live reload
.\.venv\Scripts\uvicorn.exe src.main:app --reload --port 8000
```

- **Base URL**: `http://localhost:8000/api/v1`
- **Interactive Swagger Docs**: `http://localhost:8000/docs`
- **ReDoc Documentation**: `http://localhost:8000/redoc`
- **Health Check**: `http://localhost:8000/health`

**Seed Credentials**:
- **Admin**: `admin@docfind.cm` / `admin1234`
- **Citizen / Finder**: `demo@docfind.cm` / `demo1234`

---

### 2. Admin Web Dashboard (`apps/admin`)

The moderation dashboard is built with Vue 3 (Composition API), TypeScript strict mode, and Tailwind CSS.

```bash
cd apps/admin

# Install dependencies
npm install

# Start development server (with Vite proxy to http://localhost:8000)
npm run dev
```

- **Dashboard URL**: `http://localhost:5173`
- **Features**:
  - **Overview**: 4 KPI cards, 7-day dual-bar activity chart, live moderation activity feed.
  - **Review Queue**: Quality scoring, frosted glass reveal, blur slider (2–14px), keyboard shortcuts (`A` approve, `R` reject, `↑`/`↓` navigate), reject modal.
  - **Claims**: Side-by-side proof verification table, risk pills, claimant chat, Cameroon pickup point assignment modal.
  - **Listings**: Filterable data table, auto-archive banner, partner CSV bulk upload.
  - **Fraud**: Suspend user and dismiss actions.
  - **Audit Log**: Sensitive filter toggle (`?sensitive_only=true`).
  - **Settings**: Moderation policies, language toggle (en/fr), theme switch (System/Light/Dark).

---

### 3. Mobile Application (`apps/mobile`)

The mobile application is built with Flutter and Riverpod Clean Architecture.

```bash
cd apps/mobile

# Fetch packages and generate localization files
flutter pub get
flutter gen-l10n

# Run mobile app (connected emulator or device)
flutter run
```

- **Supported Platforms**: Android (`minSdkVersion 21` / Android 5.0+), iOS (`12.0+`), macOS, Web, Linux, Windows.
- **Features**:
  - Bilingual localization (`en` / `fr`) with instant runtime toggle.
  - Light and Dark modes with responsive dynamic font scaling up to 200%.
  - 12 comprehensive screens: Splash, Onboarding, Auth with Law 2024/017 opt-in, Shell with unread badges, Search feed with filters and 300ms debounce, Listing detail, Claim bottom sheet, Messages & interactive chat, 3-step Report flow with camera scan line and dual consents, Saved alerts, Profile & settings.

---

## 🧪 Comprehensive Verification & Test Suite

The monorepo enforces **100% test pass rate** with code coverage exceeding the $\ge 80\%$ Definition of Done across every tier:

| Package | Test Framework | Test Count | Code Coverage | Status |
|---|---|---|---|---|
| **Mobile (`apps/mobile`)** | Flutter Test / WidgetTester | **68 / 68 passed** | **82.69%** | ✅ Passed |
| **Admin (`apps/admin`)** | Vitest / Vue Test Utils | **88 / 88 passed** | **90.44%** | ✅ Passed |
| **Backend (`services/api`)** | Pytest / AnyIO / TestClient | **25 / 25 passed** | **92.00%** | ✅ Passed |
| **Monorepo Total** | — | **181 / 181 passed (100%)** | **> 85% Monorepo Avg** | ✅ Passed |

### Running the Test Suites

```bash
# 1. Run Mobile Tests & Static Analysis
cd apps/mobile
flutter analyze
flutter test --coverage

# 2. Run Admin Tests & Type-Check
cd apps/admin
npm run type-check
npm run test:coverage
npm run build

# 3. Run Backend Tests & Coverage
cd services/api
.\.venv\Scripts\pytest.exe --cov=src --cov-fail-under=80
```

---

## 📋 API Overview

| Group | Method | Endpoint | Description |
|---|---|---|---|
| **Auth** | `POST` | `/api/v1/auth/register` | Register new user with mandatory Law 2024/017 consent |
| **Auth** | `POST` | `/api/v1/auth/login` | Authenticate and obtain JWT Bearer access token |
| **Auth** | `GET` | `/api/v1/auth/me` | Fetch profile for current authenticated user |
| **Submissions** | `POST` | `/api/v1/submissions/` | Create finder report with dual photo & location consents |
| **Submissions** | `GET` | `/api/v1/submissions/my` | Retrieve submissions by authenticated finder |
| **Listings** | `GET` | `/api/v1/listings/` | Search approved public documents (type, town, query) |
| **Listings** | `GET` | `/api/v1/listings/{id}` | Retrieve individual public listing details |
| **Claims** | `POST` | `/api/v1/claims/` | Submit ownership claim with secret proof answer |
| **Claims** | `GET` | `/api/v1/claims/my` | Retrieve claims submitted by current user |
| **Claims** | `POST` | `/api/v1/claims/{id}/messages` | Post a message to claim discussion thread |
| **Alerts** | `GET` | `/api/v1/alerts/` | List registered search notification alerts |
| **Alerts** | `POST` | `/api/v1/alerts/` | Create new search notification alert |
| **Alerts** | `DELETE`| `/api/v1/alerts/{id}` | Remove search notification alert |
| **Admin** | `GET` | `/api/v1/admin/overview` | KPI summary statistics for moderation dashboard |
| **Admin** | `GET` | `/api/v1/admin/queue` | Queue of pending finder submissions |
| **Admin** | `POST` | `/api/v1/admin/queue/{id}/approve` | Approve submission and publish public listing |
| **Admin** | `POST` | `/api/v1/admin/queue/{id}/reject` | Reject submission with formal reason |
| **Admin** | `POST` | `/api/v1/admin/queue/{id}/reveal` | Unmask unredacted original photo (audit logged) |
| **Admin** | `POST` | `/api/v1/admin/claims/{id}/status` | Update claim verification status and handoff |
| **Admin** | `POST` | `/api/v1/admin/listings/{id}/status` | Update listing status (live, recovered, archived) |
| **Admin** | `GET` | `/api/v1/admin/fraud` | Fetch reported fraud incidents |
| **Admin** | `POST` | `/api/v1/admin/fraud/{id}/action` | Suspend reported user or dismiss report |
| **Admin** | `GET` | `/api/v1/admin/audit` | Chronological audit trail with sensitive filter |

---

## 📄 License & Legal Notice

This software is developed in accordance with the regulatory standards of the Republic of Cameroon, specifically **Law No. 2024/017 on the Protection of Personal Data**. Unauthorized dissemination, scraping, or publication of unredacted personal identification data is strictly prohibited.
