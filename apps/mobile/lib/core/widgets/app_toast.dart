import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

/// Top-floating pill toast matching the wireframe specification.
/// Displays for ~2.6 seconds, announces to screen readers, and smoothly animates.
abstract final class AppToast {
  static OverlayEntry? _currentEntry;
  static Timer? _dismissTimer;

  static void show(BuildContext context, String message) {
    _dismissTimer?.cancel();
    _currentEntry?.remove();
    _currentEntry = null;

    final OverlayState overlay = Overlay.of(context);

    // Announce for accessibility / TalkBack
    SemanticsService.sendAnnouncement(
      View.of(context),
      message,
      TextDirection.ltr,
    );

    final OverlayEntry entry = OverlayEntry(
      builder: (BuildContext ctx) => _ToastWidget(
        message: message,
        onDismiss: () {
          _currentEntry?.remove();
          _currentEntry = null;
        },
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);

    _dismissTimer = Timer(AppMotion.toastDuration, () {
      _currentEntry?.remove();
      _currentEntry = null;
    });
  }
}

class _ToastWidget extends StatefulWidget {
  const _ToastWidget({required this.message, required this.onDismiss});

  final String message;
  final VoidCallback onDismiss;

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.6), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: AppMotion.screenPushCurve,
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top + 14;

    return Positioned(
      top: topPadding,
      left: 20,
      right: 20,
      child: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF10231A),
                  borderRadius: AppRadius.pill,
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x4D000000),
                      blurRadius: 24,
                      offset: Offset(0, 8),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(
                      Icons.check_circle_outline,
                      size: 18,
                      color: AppColors.lightSun,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        widget.message,
                        style: AppTypography.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
