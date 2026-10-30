import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/document_types.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/redacted_doc.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _cardDropController;
  late final AnimationController _lensSweepController;
  late final AnimationController _textFadeController;
  late final AnimationController _exitController;

  late final Animation<double> _cardDropAnimation;
  late final Animation<double> _cardRotateAnimation;
  late final Animation<Offset> _lensOffsetAnimation;
  late final Animation<double> _textFadeAnimation;
  late final Animation<double> _exitFadeAnimation;
  late final Animation<double> _exitScaleAnimation;

  Timer? _completeTimer;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();

    // 1. Card drop animation (spring)
    _cardDropController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _cardDropAnimation = Tween<double>(begin: -140, end: 0).animate(
      CurvedAnimation(
        parent: _cardDropController,
        curve: const Cubic(0.17, 0.89, 0.32, 1.25),
      ),
    );
    _cardRotateAnimation = Tween<double>(begin: -0.08, end: 0).animate(
      CurvedAnimation(parent: _cardDropController, curve: Curves.easeOutBack),
    );

    // 2. Yellow lens sweep
    _lensSweepController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _lensOffsetAnimation =
        Tween<Offset>(
          begin: const Offset(-0.8, -0.4),
          end: const Offset(0.9, 0.3),
        ).animate(
          CurvedAnimation(
            parent: _lensSweepController,
            curve: Curves.easeInOutCubic,
          ),
        );

    // 3. Text fade up
    _textFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _textFadeAnimation = CurvedAnimation(
      parent: _textFadeController,
      curve: Curves.easeOut,
    );

    // 4. Fade & Scale out
    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _exitFadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _exitController, curve: Curves.easeIn));
    _exitScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.04,
    ).animate(CurvedAnimation(parent: _exitController, curve: Curves.easeIn));

    _startSequence();
  }

  void _startSequence() {
    _cardDropController.forward();

    Future<void>.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _lensSweepController.forward();
    });

    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (mounted) _textFadeController.forward();
    });

    _completeTimer = Timer(AppConstants.splashDuration, () {
      _proceed();
    });
  }

  Future<void> _proceed() async {
    if (_isNavigating || !mounted) return;
    _isNavigating = true;
    _completeTimer?.cancel();

    await _exitController.forward();
    if (!mounted) return;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool introSeen = prefs.getBool(AppConstants.keyIntroSeen) ?? false;
    final AuthState authState = ref.read(authControllerProvider);

    if (!mounted) return;

    if (!introSeen) {
      context.go(RoutePaths.onboarding);
    } else if (!authState.isAuthenticated) {
      context.go(RoutePaths.auth);
    } else {
      context.go(RoutePaths.search);
    }
  }

  @override
  void dispose() {
    _completeTimer?.cancel();
    _cardDropController.dispose();
    _lensSweepController.dispose();
    _textFadeController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _proceed,
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: AppColors.lightPrimary,
        body: AnimatedBuilder(
          animation: _exitController,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: _exitFadeAnimation,
              child: ScaleTransition(scale: _exitScaleAnimation, child: child),
            );
          },
          child: Stack(
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // Card Stage with dropping card and sweeping yellow lens
                    SizedBox(
                      width: 220,
                      height: 140,
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: <Widget>[
                          // Dropping Document Card
                          AnimatedBuilder(
                            animation: _cardDropController,
                            builder: (BuildContext context, Widget? child) {
                              return Transform.translate(
                                offset: Offset(0, _cardDropAnimation.value),
                                child: Transform.rotate(
                                  angle: _cardRotateAnimation.value,
                                  child: child,
                                ),
                              );
                            },
                            child: const RedactedDoc(
                              type: DocumentType.id,
                              width: 170,
                              height: 108,
                            ),
                          ),
                          // Sweeping Yellow Magnifier Lens
                          AnimatedBuilder(
                            animation: _lensSweepController,
                            builder: (BuildContext context, Widget? child) {
                              return Align(
                                alignment: Alignment(
                                  _lensOffsetAnimation.value.dx,
                                  _lensOffsetAnimation.value.dy,
                                ),
                                child: Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.lightSun,
                                      width: 4,
                                    ),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: AppColors.lightSun.withValues(
                                          alpha: 0.35,
                                        ),
                                        blurRadius: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Fade-up Title & Tagline
                    FadeTransition(
                      opacity: _textFadeAnimation,
                      child: Column(
                        children: <Widget>[
                          Text(
                            context.l10n.appName,
                            style: AppTypography.displayLarge.copyWith(
                              color: Colors.white,
                              fontSize: 32,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 36),
                            child: Text(
                              context.l10n.appTagline,
                              textAlign: TextAlign.center,
                              style: AppTypography.bodySmall.copyWith(
                                color: Colors.white.withValues(alpha: 0.82),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Tap anywhere hint
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'Tap anywhere to skip',
                    style: AppTypography.caption.copyWith(
                      color: Colors.white.withValues(alpha: 0.45),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
