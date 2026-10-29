import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Empty state widget matching the wireframe empty state design.
class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    required this.title,
    required this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String title;
  final String message;
  final Widget? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Illustrated icon circle / orb
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkGreenTint
                    : AppColors.lightGreenTint,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child:
                  icon ??
                  const Icon(
                    Icons.search_off_rounded,
                    size: 36,
                    color: AppColors.lightPrimary,
                  ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: AppTypography.displayMedium.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...<Widget>[
              const SizedBox(height: AppSpacing.xl),
              OutlinedButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
