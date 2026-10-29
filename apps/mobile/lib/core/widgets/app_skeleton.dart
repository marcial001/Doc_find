import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

/// Skeleton loader with pulse animation for low-end device efficiency.
class AppSkeleton extends StatefulWidget {
  const AppSkeleton({
    this.width,
    this.height = 16,
    this.borderRadius,
    super.key,
  });

  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  /// Skeleton for a document result card
  static Widget card() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.card,
        border: Border.all(color: const Color(0xFFE4EBE6)),
      ),
      child: const Row(
        children: <Widget>[
          AppSkeleton(width: 76, height: 48, borderRadius: AppRadius.sm),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AppSkeleton(width: 80, height: 12),
                SizedBox(height: 8),
                AppSkeleton(width: 140, height: 16),
                SizedBox(height: 6),
                AppSkeleton(width: 180, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.35,
      end: 0.85,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color baseColor = isDark
        ? AppColors.darkLine
        : const Color(0xFFD5DED8);

    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: baseColor.withValues(alpha: _animation.value),
            borderRadius: widget.borderRadius ?? AppRadius.sm,
          ),
        );
      },
    );
  }
}
