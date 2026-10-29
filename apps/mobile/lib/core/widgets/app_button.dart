import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

enum ButtonVariant { primary, ghost, danger }

/// Primary, ghost or destructive button matching the Doc-Find design system.
class AppButton extends StatefulWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final bool isLoading;
  final Widget? icon;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bool isEnabled = widget.onPressed != null && !widget.isLoading;

    Color bgColor;
    Color fgColor;
    Border? border;
    List<BoxShadow> shadows = const <BoxShadow>[];

    switch (widget.variant) {
      case ButtonVariant.primary:
        bgColor = isDark ? AppColors.darkPrimary : AppColors.lightPrimary;
        fgColor = isDark ? AppColors.darkOnPrimary : AppColors.lightOnPrimary;
        if (isEnabled) {
          shadows = <BoxShadow>[
            BoxShadow(
              color: bgColor.withValues(alpha: 0.25),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ];
        }
        break;
      case ButtonVariant.ghost:
        bgColor = Colors.transparent;
        fgColor = theme.colorScheme.onSurface;
        border = Border.all(
          color: isDark ? AppColors.darkLine : AppColors.lightLine,
          width: 1,
        );
        break;
      case ButtonVariant.danger:
        bgColor = AppColors.lightRed;
        fgColor = Colors.white;
        break;
    }

    if (!isEnabled) {
      bgColor = bgColor.withValues(alpha: 0.45);
      fgColor = fgColor.withValues(alpha: 0.6);
      shadows = const <BoxShadow>[];
    }

    return GestureDetector(
      onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: Container(
          constraints: const BoxConstraints(
            minHeight: AppSpacing.minTouchTarget,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: AppRadius.button,
            border: border,
            boxShadow: shadows,
          ),
          clipBehavior: Clip.antiAlias,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isEnabled ? widget.onPressed : null,
              borderRadius: AppRadius.button,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                child: Center(
                  child: widget.isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            valueColor: AlwaysStoppedAnimation<Color>(fgColor),
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            if (widget.icon != null) ...<Widget>[
                              widget.icon!,
                              const SizedBox(width: 8),
                            ],
                            Text(
                              widget.label,
                              style: AppTypography.button.copyWith(
                                color: fgColor,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
