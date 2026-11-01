# Architecture & Engineering Decisions

- 2026-10-29: Initialized monorepo repository structure (`apps/mobile`, `apps/admin`, `services/api`, `design`, `docs`).
- 2026-10-29: Generated headless browser screenshots across 24 mobile states and 11 admin states in `design/screenshots/` to serve as visual baselines.
- 2026-10-29: Established strict `minSdkVersion 21` (Android 5.0) support with multiDex and desugaring in the Flutter project configuration.
- 2026-10-29: Selected `flutter_riverpod` for unidirectional data flow and compile-safe dependency injection.
- 2026-10-29: Chosen `Result<T, Failure>` value type pattern for robust, predictable error handling without uncaught widget exceptions.
- 2026-10-29: Offline-first architecture for mock repositories implementing domain repository interfaces, ensuring zero UI changes when swapping in remote REST/Supabase datasources.
- 2026-10-29: Adopted local bundled asset fonts (`Bricolage Grotesque` and `Figtree`) to prevent network calls and guarantee offline availability.
- 2026-10-30: Implemented Cameroon Law No. 2024/017 compliance across all forms: explicit, unchecked-by-default dual consents for document storage and contact coordination; unredacted data is kept isolated from the public UI.
- 2026-10-30: Connected top-level dynamic unread badge count to `MessagesController.totalUnread` so bottom navigation and shell app bar bell icon reactively reflect incoming conversations and claims.
- 2026-10-30: Admin Dashboard frontend (`apps/admin`) built with Vue 3 (Composition API `<script setup>`), TypeScript strict mode, Tailwind CSS with design tokens mapped to CSS variables, and Pinia stores with deep-cloned state initialization for test isolation.
- 2026-10-30: Preserved Cameroon Law No. 2024/017 in Admin console: originals are hidden behind a frosted glass overlay (`Original is hidden · Viewing is logged`); unlocking triggers an explicit audit log event (`s: 1`, Sensitive) and notification.
- 2026-10-30: Review queue supports keyboard accessibility (`A` to approve, `R` to reject modal, `ArrowUp`/`ArrowDown` navigation) and live redaction slider preview with quality score badges.
- 2026-10-30: Master-detail views (`/queue` and `/claims`) adapt dynamically: two-column layout on desktop, stacked with a dedicated "← Back" button on mobile (<820px).
- 2026-10-30: Vitest test suite achieved 88/88 passing tests and 90.44% statement coverage / 91.79% lines coverage, surpassing the ≥80% Definition of Done requirement.
- 2026-10-30: Built Phase 3 Backend API (`services/api`) with FastAPI, SQLAlchemy 2.0, and Pydantic v2. Utilized native `bcrypt` cryptographic hashing for seamless Python 3.12 compatibility.
- 2026-10-30: Hardened Cameroon Law No. 2024/017 at the API layer: mandatory dual consents for submissions (`photo_consent`, `location_consent`), mandatory opt-in on user registration, and sensitive audit logging (`is_sensitive=True`) on original unredacted photo reveals and claimant flags.
- 2026-10-30: Pytest test suite achieved 25/25 passing tests (100%) and 92% statement coverage, surpassing the ≥80% Definition of Done requirement.
