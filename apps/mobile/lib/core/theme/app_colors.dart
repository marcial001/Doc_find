import 'package:flutter/material.dart';

/// Design system color tokens extracted from the HTML wireframes.
abstract final class AppColors {
  // Light Palette
  static const Color lightBackground = Color(0xFFE4EBE6);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightInk = Color(0xFF10231A);
  static const Color lightMuted = Color(0xFF5C6B63);
  static const Color lightPrimary = Color(0xFF0E6B47);
  static const Color lightGreenTint = Color(0xFFDCEDE3);
  static const Color lightSun = Color(0xFFF5B700);
  static const Color lightRed = Color(0xFFC9382C);
  static const Color lightLine = Color(0xFFD5DED8);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);

  // Dark Palette
  static const Color darkBackground = Color(0xFF070D0A);
  static const Color darkSurface = Color(0xFF14201A);
  static const Color darkInk = Color(0xFFE8F0EB);
  static const Color darkMuted = Color(0xFF93A59A);
  static const Color darkPrimary = Color(0xFF3DBF86);
  static const Color darkGreenTint = Color(0xFF1B3A2C);
  static const Color darkSun = Color(0xFFF5B700);
  static const Color darkRed = Color(0xFFE24C40);
  static const Color darkLine = Color(0xFF26372E);
  static const Color darkOnPrimary = Color(0xFF06140D);

  // Document-Type Colors (Shared across light and dark)
  static const Color docId = Color(0xFF2E7D5B);
  static const Color docPassport = Color(0xFF274C9B);
  static const Color docBirth = Color(0xFFB4741C);
  static const Color docLicence = Color(0xFF8A3AA3);
  static const Color docOther = Color(0xFF5C6B63);

  // Avatar Swatches (Profile color choice)
  static const List<Color> avatarSwatches = <Color>[
    Color(0xFF0E6B47), // Primary Green
    Color(0xFF274C9B), // Blue
    Color(0xFF8A3AA3), // Purple
    Color(0xFFB4741C), // Ochre/Orange
    Color(0xFFC9382C), // Red
  ];
}
