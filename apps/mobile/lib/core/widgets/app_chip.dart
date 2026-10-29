import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

/// Pill chip matching the Doc-Find design system with 1.04 scale transition on selection.
class AppChip extends StatelessWidget {
  const AppChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.badge,
    this.badgeColor,
    super.key,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final String? badge;
  final Color? badgeColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bgColor = isSelected
        ? (isDark ? AppColors.darkGreenTint : AppColors.lightGreenTint)
        : theme.colorScheme.surface;

    final Color textColor = isSelected
        ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
        : theme.colorScheme.onSurface;

    final Color borderColor = isSelected
        ? Colors.transparent
        : (isDark ? AppColors.darkLine : AppColors.lightLine);

    return AnimatedScale(
      scale: isSelected ? AppMotion.chipSelectScale : 1.0,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      child: Semantics(
        button: true,
        selected: isSelected,
        label: label,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadius.pill,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: AppRadius.pill,
                border: Border.all(color: borderColor, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (badge != null) ...<Widget>[
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: badgeColor ?? textColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    label,
                    style: AppTypography.caption.copyWith(
                      color: textColor,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
