# Architecture & Engineering Decisions

- 2026-10-29: Initialized monorepo repository structure (`apps/mobile`, `apps/admin`, `services/api`, `design`, `docs`).
- 2026-10-29: Generated headless browser screenshots across 24 mobile states and 11 admin states in `design/screenshots/` to serve as visual baselines.
- 2026-10-29: Established strict `minSdkVersion 21` (Android 5.0) support with multiDex and desugaring in the Flutter project configuration.
- 2026-10-29: Selected `flutter_riverpod` for unidirectional data flow and compile-safe dependency injection.
- 2026-10-29: Chosen `Result<T, Failure>` value type pattern for robust, predictable error handling without uncaught widget exceptions.
- 2026-10-29: Offline-first architecture for mock repositories implementing domain repository interfaces, ensuring zero UI changes when swapping in remote REST/Supabase datasources.
- 2026-10-29: Adopted local bundled asset fonts (`Bricolage Grotesque` and `Figtree`) to prevent network calls and guarantee offline availability.
