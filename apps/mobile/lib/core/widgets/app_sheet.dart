import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

/// Modal bottom sheet following the Doc-Find design system (26 dp top radius, grab bar).
abstract final class AppSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = true,
    bool isDismissible = true,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.sheet),
      clipBehavior: Clip.antiAlias,
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Centered grab handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkLine
                            : AppColors.lightLine,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.base),
                  child,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
