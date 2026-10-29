import 'package:flutter/material.dart';

abstract final class AppMotion {
  // Durations
  static const Duration screenPushDuration = Duration(milliseconds: 380);
  static const Duration sheetDuration = Duration(milliseconds: 400);
  static const Duration listEntranceDuration = Duration(milliseconds: 400);
  static const Duration listStaggerDelay = Duration(milliseconds: 50);
  static const Duration toastDuration = Duration(milliseconds: 2600);
  static const Duration checkmarkDrawDuration = Duration(milliseconds: 500);
  static const Duration tapFeedbackDuration = Duration(milliseconds: 100);
  static const Duration debounceDuration = Duration(milliseconds: 300);

  // Curves
  static const Cubic screenPushCurve = Cubic(0.2, 0.8, 0.2, 1.0);
  static const Curve sheetCurve = Curves.easeOutCubic;
  static const Curve checkmarkCurve = Curves.easeInOutCubic;
  static const double chipSelectScale = 1.04;

  /// Helper to check if reduced motion is requested by the OS.
  static bool isReduceMotion(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }
}
