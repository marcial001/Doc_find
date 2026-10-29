import 'package:flutter/material.dart';
import '../constants/document_types.dart';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'redacted_doc.dart';

/// Card displaying a found document in search results or recent reports list.
class DocCard extends StatefulWidget {
  const DocCard({
    required this.id,
    required this.type,
    required this.name,
    required this.town,
    required this.spot,
    required this.daysAgo,
    this.onTap,
    this.animationIndex = 0,
    super.key,
  });

  final int id;
  final DocumentType type;
  final String name;
  final String town;
  final String spot;
  final int daysAgo;
  final VoidCallback? onTap;
  final int animationIndex;

  @override
  State<DocCard> createState() => _DocCardState();
}

class _DocCardState extends State<DocCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppMotion.listEntranceDuration,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    final int delayMs =
        widget.animationIndex * AppMotion.listStaggerDelay.inMilliseconds;
    Future<void>.delayed(Duration(milliseconds: delayMs), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatWhen(int days) {
    if (days == 0) return 'Today';
    if (days == 1) return 'Yesterday';
    return '$days days ago';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: AppRadius.card,
            border: Border.all(
              color: isDark ? AppColors.darkLine : AppColors.lightLine,
              width: 1,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: (isDark ? Colors.black : const Color(0xFF10231A))
                    .withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              splashColor: widget.type.color.withValues(alpha: 0.08),
              highlightColor: widget.type.color.withValues(alpha: 0.04),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Left: Redacted Document Thumbnail
                    RedactedDoc(type: widget.type, isLarge: false),
                    const SizedBox(width: AppSpacing.md),
                    // Right: Information Column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Top row: Document type pill + When
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: widget.type.color.withValues(
                                    alpha: 0.12,
                                  ),
                                  borderRadius: AppRadius.pill,
                                ),
                                child: Text(
                                  widget.type.label,
                                  style: AppTypography.caption.copyWith(
                                    color: widget.type.color,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Text(
                                _formatWhen(widget.daysAgo),
                                style: AppTypography.caption.copyWith(
                                  color: isDark
                                      ? AppColors.darkMuted
                                      : AppColors.lightMuted,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          // Document holder name (redacted)
                          Text(
                            widget.name,
                            style: AppTypography.heading2.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          // Location: Town · Spot
                          Text(
                            '${widget.town} · ${widget.spot}',
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark
                                  ? AppColors.darkMuted
                                  : AppColors.lightMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
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
