# Wireframe Deviations & Improvements

This log documents all intentional deviations and improvements over the raw HTML wireframes, in accordance with the Master Build Prompt.

- 2026-10-29: Replaced wireframe's runtime DOM mutation translation hack with standard Flutter ARB (`app_en.arb`, `app_fr.arb`) files and `flutter_localizations` (`intl`), supporting compile-time safety and instant runtime switching without app reload.
- 2026-10-29: Replaced fixed-height CSS viewport assumptions with flexible scroll views and LayoutBuilders supporting 200% dynamic font scaling without overflow.
- 2026-10-29: Replaced web-only mock phone bezel with native edge-to-edge Flutter viewports and system safe-area insets.
- 2026-10-29: Added 300 ms debouncing to the search input field to prevent unnecessary computation on every keystroke.
- 2026-10-29: Enforced recommended password length ≥ 8 characters with client-side guidance and validation while maintaining mock login compatibility.
- 2026-10-30: In Messages chat flow, replaced inline HTML setTimeout mock with Riverpod reactive controller and timer that gracefully renders an animated 3-dot typing bubble indicator before appending team replies.
- 2026-10-30: In Report flow, added animated laser line, corner brackets, and simulated snapshot flash to replicate the viewfinder experience without requiring hardware camera permissions during mock phase.
- 2026-10-30: In Profile & Settings, wired ThemeMode (system/light/dark) and Locale (en/fr) to top-level Riverpod StateNotifier providers directly controlling MaterialApp.router.
