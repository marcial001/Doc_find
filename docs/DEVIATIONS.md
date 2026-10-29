# Wireframe Deviations & Improvements

This log documents all intentional deviations and improvements over the raw HTML wireframes, in accordance with the Master Build Prompt.

- 2026-10-29: Replaced wireframe's runtime DOM mutation translation hack with standard Flutter ARB (`app_en.arb`, `app_fr.arb`) files and `flutter_localizations` (`intl`), supporting compile-time safety and instant runtime switching without app reload.
- 2026-10-29: Replaced fixed-height CSS viewport assumptions with flexible scroll views and LayoutBuilders supporting 200% dynamic font scaling without overflow.
- 2026-10-29: Replaced web-only mock phone bezel with native edge-to-edge Flutter viewports and system safe-area insets.
- 2026-10-29: Added 300 ms debouncing to the search input field to prevent unnecessary computation on every keystroke.
- 2026-10-29: Enforced recommended password length ≥ 8 characters with client-side guidance and validation while maintaining mock login compatibility.
