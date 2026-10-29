import 'package:doc_find/core/theme/app_colors.dart';
import 'package:doc_find/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme', () {
    test('light theme has correct colors and brightness', () {
      final ThemeData theme = AppTheme.light();
      expect(theme.brightness, Brightness.light);
      expect(theme.scaffoldBackgroundColor, AppColors.lightBackground);
      expect(theme.colorScheme.primary, AppColors.lightPrimary);
      expect(theme.colorScheme.surface, AppColors.lightSurface);
      expect(theme.colorScheme.error, AppColors.lightRed);
    });

    test('dark theme has correct colors and brightness', () {
      final ThemeData theme = AppTheme.dark();
      expect(theme.brightness, Brightness.dark);
      expect(theme.scaffoldBackgroundColor, AppColors.darkBackground);
      expect(theme.colorScheme.primary, AppColors.darkPrimary);
      expect(theme.colorScheme.surface, AppColors.darkSurface);
      expect(theme.colorScheme.error, AppColors.darkRed);
    });
  });
}
