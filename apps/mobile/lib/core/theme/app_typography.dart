import 'package:flutter/material.dart';

abstract final class AppTypography {
  static const String headingFont = 'Bricolage Grotesque';
  static const String bodyFont = 'Figtree';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: headingFont,
    fontWeight: FontWeight.w800,
    fontSize: 28,
    letterSpacing: -0.02 * 28,
    height: 1.2,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: headingFont,
    fontWeight: FontWeight.w800,
    fontSize: 22,
    letterSpacing: -0.02 * 22,
    height: 1.25,
  );

  static const TextStyle heading1 = TextStyle(
    fontFamily: headingFont,
    fontWeight: FontWeight.w700,
    fontSize: 20,
    letterSpacing: -0.02 * 20,
    height: 1.3,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: headingFont,
    fontWeight: FontWeight.w600,
    fontSize: 17,
    letterSpacing: -0.02 * 17,
    height: 1.35,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: bodyFont,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 1.45,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: bodyFont,
    fontWeight: FontWeight.w400,
    fontSize: 15,
    height: 1.45,
  );

  static const TextStyle bodySemiBold = TextStyle(
    fontFamily: bodyFont,
    fontWeight: FontWeight.w600,
    fontSize: 15,
    height: 1.45,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: bodyFont,
    fontWeight: FontWeight.w400,
    fontSize: 13,
    height: 1.4,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: bodyFont,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 1.35,
  );

  static const TextStyle button = TextStyle(
    fontFamily: bodyFont,
    fontWeight: FontWeight.w600,
    fontSize: 15,
    height: 1.2,
  );
}
