import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Custom toggle switch matching the Doc-Find design system with spring thumb animation.
class AppSwitch extends StatelessWidget {
  const AppSwitch({
    required this.value,
    required this.onChanged,
    this.semanticLabel,
    super.key,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color trackColor = value
        ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
        : (isDark ? AppColors.darkLine : AppColors.lightLine);

    return Semantics(
      toggled: value,
      label: semanticLabel,
      child: GestureDetector(
        onTap: () => onChanged(!value),
        behavior: HitTestBehavior.opaque,
        child: Container(
          // Ensure touch target >= 48x48
          constraints: const BoxConstraints(
            minWidth: AppSpacing.minTouchTarget,
            minHeight: AppSpacing.minTouchTarget,
          ),
          alignment: Alignment.center,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: 44,
            height: 26,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: trackColor,
              borderRadius: BorderRadius.circular(13),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutBack, // Spring thumb
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
