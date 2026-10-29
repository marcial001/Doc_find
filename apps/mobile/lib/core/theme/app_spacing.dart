import 'package:flutter/material.dart';

abstract final class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 40;

  /// Touch targets must be >= 48x48 dp for accessibility.
  static const double minTouchTarget = 48;

  // Insets
  static const EdgeInsets edgeInsetsScreen = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: base,
  );
  static const EdgeInsets edgeInsetsCard = EdgeInsets.all(base);
  static const EdgeInsets edgeInsetsSheet = EdgeInsets.fromLTRB(lg, md, lg, xl);
}
