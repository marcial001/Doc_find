import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_toast.dart';
import '../controllers/auth_controller.dart';

enum AuthMode { login, register }

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen>
    with SingleTickerProviderStateMixin {
  AuthMode _mode = AuthMode.login;

  // Controllers
  final TextEditingController _loginIdentifierController =
      TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();

  final TextEditingController _regNameController = TextEditingController();
  final TextEditingController _regPhoneController = TextEditingController();
  final TextEditingController _regEmailController = TextEditingController();
  final TextEditingController _regPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _consentGranted = false;
  String? _clientValidationError;

  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _loginIdentifierController.dispose();
    _loginPasswordController.dispose();
    _regNameController.dispose();
    _regPhoneController.dispose();
    _regEmailController.dispose();
    _regPasswordController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _triggerShake() {
    _shakeController.forward(from: 0.0);
  }

  void _fillDemoCredentials() {
    _loginIdentifierController.text = AppConstants.mockDemoEmail;
    _loginPasswordController.text = AppConstants.mockDemoPassword;
    setState(() => _clientValidationError = null);
  }

  Future<void> _submitLogin() async {
    final String id = _loginIdentifierController.text.trim();
    final String pw = _loginPasswordController.text;

    if (!Validators.isValidEmailOrPhone(id)) {
      setState(
        () => _clientValidationError =
            'Please enter a valid email or 9-digit phone number.',
      );
      _triggerShake();
      return;
    }
    if (!Validators.isValidPassword(pw)) {
      setState(
        () =>
            _clientValidationError = 'Password must be at least 6 characters.',
      );
      _triggerShake();
      return;
    }

    setState(() => _clientValidationError = null);
    final bool success = await ref
        .read(authControllerProvider.notifier)
        .login(id, pw);

    if (success && mounted) {
      final user = ref.read(authControllerProvider).user;
      final String name = user != null ? user.name.split(' ').first : '';
      AppToast.show(context, context.l10n.authWelcomeToast(name));
      context.go(RoutePaths.search);
    } else {
      _triggerShake();
    }
  }

  Future<void> _submitRegister() async {
    final String name = _regNameController.text.trim();
    final String phone = _regPhoneController.text.trim();
    final String email = _regEmailController.text.trim();
    final String pw = _regPasswordController.text;

    if (!Validators.isValidName(name)) {
      setState(
        () =>
            _clientValidationError = 'Full name must be at least 2 characters.',
      );
      _triggerShake();
      return;
    }
    if (!Validators.isValidPhone(phone)) {
      setState(
        () => _clientValidationError =
            'Phone must be a valid 9-digit Cameroon number starting with 6.',
      );
      _triggerShake();
      return;
    }
    if (!Validators.isValidEmail(email)) {
      setState(
        () => _clientValidationError = 'Please enter a valid email address.',
      );
      _triggerShake();
      return;
    }
    if (!Validators.isValidPassword(pw)) {
      setState(
        () => _clientValidationError =
            'Password must be at least 6 characters (8+ recommended).',
      );
      _triggerShake();
      return;
    }
    if (!_consentGranted) {
      setState(
        () => _clientValidationError =
            'You must accept the Law No. 2024/017 privacy consent to create an account.',
      );
      _triggerShake();
      return;
    }

    setState(() => _clientValidationError = null);
    final bool success = await ref
        .read(authControllerProvider.notifier)
        .register(
          name: name,
          phone: phone,
          email: email,
          password: pw,
          consentGranted: _consentGranted,
        );

    if (success && mounted) {
      final user = ref.read(authControllerProvider).user;
      final String shortName = user != null ? user.name.split(' ').first : '';
      AppToast.show(context, context.l10n.authWelcomeToast(shortName));
      context.go(RoutePaths.search);
    } else {
      _triggerShake();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final AuthState authState = ref.watch(authControllerProvider);
    final String? activeError =
        _clientValidationError ?? authState.errorMessage;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Green Header Band
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 28),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Logo mark
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.document_scanner_rounded,
                      color: AppColors.lightPrimary,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _mode == AuthMode.login
                        ? context.l10n.authWelcomeBack
                        : context.l10n.authCreateAccount,
                    style: AppTypography.displayLarge.copyWith(
                      color: Colors.white,
                      fontSize: 26,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _mode == AuthMode.login
                        ? context.l10n.authWelcomeBackSub
                        : context.l10n.authCreateAccountSub,
                    style: AppTypography.bodySmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
            // Form Body
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Animated Segmented Control
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkLine
                          : const Color(0xFFE8EFEA),
                      borderRadius: AppRadius.button,
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: _SegmentButton(
                            label: context.l10n.authLogIn,
                            isSelected: _mode == AuthMode.login,
                            onTap: () {
                              ref
                                  .read(authControllerProvider.notifier)
                                  .clearError();
                              setState(() {
                                _mode = AuthMode.login;
                                _clientValidationError = null;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: _SegmentButton(
                            label: context.l10n.authRegister,
                            isSelected: _mode == AuthMode.register,
                            onTap: () {
                              ref
                                  .read(authControllerProvider.notifier)
                                  .clearError();
                              setState(() {
                                _mode = AuthMode.register;
                                _clientValidationError = null;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Inline Error Banner with Shake Animation
                  if (activeError != null) ...<Widget>[
                    AnimatedBuilder(
                      animation: _shakeAnimation,
                      builder: (BuildContext context, Widget? child) {
                        final double offset =
                            math.sin(_shakeAnimation.value * math.pi * 4) * 8;
                        return Transform.translate(
                          offset: Offset(offset, 0),
                          child: child,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lightRed.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.lightRed.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            const Icon(
                              Icons.error_outline,
                              size: 20,
                              color: AppColors.lightRed,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                activeError,
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.lightRed,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  // Input Fields
                  if (_mode == AuthMode.login) ...<Widget>[
                    _InputField(
                      label: context.l10n.authEmailOrPhone,
                      hint: context.l10n.authEmailOrPhoneHint,
                      controller: _loginIdentifierController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: AppSpacing.base),
                    _InputField(
                      label: context.l10n.authPassword,
                      hint: context.l10n.authPasswordHint,
                      controller: _loginPasswordController,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AppButton(
                      label: context.l10n.authLogIn,
                      isLoading: authState.isLoading,
                      onPressed: _submitLogin,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // Quick Demo Fill-in Hint
                    Center(
                      child: InkWell(
                        onTap: _fillDemoCredentials,
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'Demo: demo@docfind.cm · demo1234  ',
                                style: AppTypography.caption.copyWith(
                                  color: isDark
                                      ? AppColors.darkMuted
                                      : AppColors.lightMuted,
                                ),
                              ),
                              Text(
                                context.l10n.authFillIn,
                                style: const TextStyle(
                                  color: AppColors.lightPrimary,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ] else ...<Widget>[
                    _InputField(
                      label: context.l10n.authFullName,
                      hint: context.l10n.authFullNameHint,
                      controller: _regNameController,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _InputField(
                      label: context.l10n.authPhone,
                      hint: context.l10n.authPhoneHint,
                      controller: _regPhoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _InputField(
                      label: context.l10n.authEmail,
                      hint: context.l10n.authEmailHint,
                      controller: _regEmailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _InputField(
                      label: context.l10n.authPassword,
                      hint: context.l10n.authPasswordHint,
                      controller: _regPasswordController,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.base),
                    // Law 2024/017 Unticked Consent Checkbox
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _consentGranted,
                            onChanged: (bool? val) =>
                                setState(() => _consentGranted = val ?? false),
                            activeColor: isDark
                                ? AppColors.darkPrimary
                                : AppColors.lightPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(
                              () => _consentGranted = !_consentGranted,
                            ),
                            child: Text(
                              context.l10n.authConsentLaw,
                              style: AppTypography.caption.copyWith(
                                color: isDark
                                    ? AppColors.darkMuted
                                    : AppColors.lightMuted,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    AppButton(
                      label: context.l10n.authRegister,
                      isLoading: authState.isLoading,
                      onPressed: _submitRegister,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTypography.button.copyWith(
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? theme.colorScheme.onSurface
                : (isDark ? AppColors.darkMuted : AppColors.lightMuted),
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.label,
    required this.hint,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: AppTypography.bodyMedium,
          decoration: InputDecoration(hintText: hint, suffixIcon: suffixIcon),
        ),
      ],
    );
  }
}
