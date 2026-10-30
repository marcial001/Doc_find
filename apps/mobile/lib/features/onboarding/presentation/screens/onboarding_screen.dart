import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late final AnimationController _ringController;

  @override
  void initState() {
    super.initState();
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _ringController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyIntroSeen, true);
    if (!mounted) return;
    context.go(RoutePaths.auth);
  }

  void _onNext() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final List<({String title, String body, String emoji})> slides =
        <({String title, String body, String emoji})>[
          (
            title: context.l10n.onboardingSlide1Title,
            body: context.l10n.onboardingSlide1Body,
            emoji: '🪪',
          ),
          (
            title: context.l10n.onboardingSlide2Title,
            body: context.l10n.onboardingSlide2Body,
            emoji: '📸',
          ),
          (
            title: context.l10n.onboardingSlide3Title,
            body: context.l10n.onboardingSlide3Body,
            emoji: '🤝',
          ),
        ];

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          TextButton(
            onPressed: _completeOnboarding,
            child: Text(
              context.l10n.onboardingSkip,
              style: AppTypography.button.copyWith(
                color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Swipeable Slides
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: slides.length,
                onPageChanged: (int page) =>
                    setState(() => _currentPage = page),
                itemBuilder: (BuildContext context, int index) {
                  final slide = slides[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xxl,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Floating Orb with slowly rotating dashed yellow ring
                        SizedBox(
                          width: 140,
                          height: 140,
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              // Rotating dashed yellow ring
                              AnimatedBuilder(
                                animation: _ringController,
                                builder: (BuildContext context, Widget? child) {
                                  return Transform.rotate(
                                    angle: _ringController.value * 2 * math.pi,
                                    child: CustomPaint(
                                      size: const Size(130, 130),
                                      painter: _DashedCirclePainter(
                                        color: AppColors.lightSun,
                                        strokeWidth: 2.5,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              // Soft Green Orb with Emoji
                              Container(
                                width: 104,
                                height: 104,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isDark
                                      ? AppColors.darkGreenTint
                                      : AppColors.lightGreenTint,
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color:
                                          (isDark
                                                  ? Colors.black
                                                  : AppColors.lightPrimary)
                                              .withValues(alpha: 0.12),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  slide.emoji,
                                  style: const TextStyle(fontSize: 46),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: AppTypography.displayMedium.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          slide.body,
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyMedium.copyWith(
                            color: isDark
                                ? AppColors.darkMuted
                                : AppColors.lightMuted,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Bottom Controls: Animated Dots + Action Button
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.sm,
                AppSpacing.xl,
                AppSpacing.xl,
              ),
              child: Column(
                children: <Widget>[
                  // Animated Dots Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(slides.length, (int i) {
                      final bool isSelected = i == _currentPage;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isSelected ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark
                                    ? AppColors.darkPrimary
                                    : AppColors.lightPrimary)
                              : (isDark
                                    ? AppColors.darkLine
                                    : AppColors.lightLine),
                          borderRadius: AppRadius.pill,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    label: _currentPage == 2
                        ? context.l10n.onboardingGetStarted
                        : context.l10n.onboardingNext,
                    onPressed: _onNext,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  _DashedCirclePainter({required this.color, required this.strokeWidth});

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double radius = size.width / 2;
    const int dashCount = 20;
    const double sweepAngle = (2 * math.pi) / (dashCount * 2);

    for (int i = 0; i < dashCount; i++) {
      final double startAngle = i * sweepAngle * 2;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) =>
      color != oldDelegate.color || strokeWidth != oldDelegate.strokeWidth;
}
