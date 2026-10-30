import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/towns.dart';
import '../../../../core/l10n/locale_controller.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/app_sheet.dart';
import '../../../../core/widgets/app_switch.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../shared/domain/entities/user.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  String? _formError;

  @override
  void initState() {
    super.initState();
    final User? user = ref.read(authControllerProvider).user;
    _nameController = TextEditingController(text: user?.name ?? 'Demo User');
    _phoneController = TextEditingController(text: user?.phone ?? '670000000');
    _emailController = TextEditingController(
      text: user?.email ?? 'demo@docfind.cm',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Color _parseHex(String hex) {
    try {
      final String clean = hex.replaceAll('#', '');
      return Color(int.parse('0xFF$clean'));
    } catch (_) {
      return AppColors.lightPrimary;
    }
  }

  void _saveProfile() {
    final String name = _nameController.text.trim();
    final String phone = Validators.normalizePhone(_phoneController.text);
    final String email = _emailController.text.trim();

    if (name.length < 2) {
      setState(() => _formError = 'Enter your full name.');
      return;
    }
    if (!Validators.isValidPhone(phone)) {
      setState(
        () => _formError = 'Enter a valid 9-digit number starting with 6.',
      );
      return;
    }
    if (!Validators.isValidEmail(email)) {
      setState(() => _formError = 'Enter a valid email address.');
      return;
    }

    setState(() => _formError = null);
    final User? current = ref.read(authControllerProvider).user;
    if (current != null) {
      final User updated = current.copyWith(
        name: name,
        phone: phone,
        email: email,
      );
      ref.read(authControllerProvider.notifier).updateProfile(updated);
      AppToast.show(context, 'Details saved');
    }
  }

  Future<void> _handleLogout() async {
    await ref.read(authControllerProvider.notifier).logout();
    if (!mounted) return;
    context.go(RoutePaths.auth);
  }

  void _showChangePasswordSheet() {
    final TextEditingController currentPwCtrl = TextEditingController();
    final TextEditingController newPwCtrl = TextEditingController();
    String? pwError;

    AppSheet.show<void>(
      context: context,
      child: StatefulBuilder(
        builder: (BuildContext sheetContext, StateSetter setModalState) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Change password',
                style: AppTypography.displayMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Current password',
                style: AppTypography.heading2.copyWith(fontSize: 14),
              ),
              const SizedBox(height: AppSpacing.xs),
              TextField(
                controller: currentPwCtrl,
                obscureText: true,
                decoration: const InputDecoration(hintText: 'Current password'),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'New password',
                style: AppTypography.heading2.copyWith(fontSize: 14),
              ),
              const SizedBox(height: AppSpacing.xs),
              TextField(
                controller: newPwCtrl,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'At least 6 characters',
                ),
              ),
              if (pwError != null) ...<Widget>[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  pwError!,
                  style: TextStyle(
                    color: isDark ? AppColors.darkRed : AppColors.lightRed,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'Update password',
                onPressed: () async {
                  final String cur = currentPwCtrl.text;
                  final String nxt = newPwCtrl.text;
                  final result = await ref
                      .read(authControllerProvider.notifier)
                      .changePassword(cur, nxt);
                  result.when(
                    success: (_) {
                      Navigator.of(sheetContext).pop();
                      AppToast.show(sheetContext, 'Password updated');
                    },
                    failure: (f) {
                      setModalState(() => pwError = f.message);
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDeleteAccountSheet() {
    AppSheet.show<void>(
      context: context,
      child: Builder(
        builder: (BuildContext sheetContext) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Delete your account?',
                style: AppTypography.displayMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Your profile and saved alerts are erased. Documents you reported stay with the team until they are returned. This cannot be undone.',
                style: AppTypography.bodyMedium.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkMuted
                      : AppColors.lightMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'Delete my account',
                variant: ButtonVariant.danger,
                onPressed: () async {
                  Navigator.of(sheetContext).pop();
                  await ref
                      .read(authControllerProvider.notifier)
                      .deleteAccount();
                  if (mounted) {
                    context.go(RoutePaths.auth);
                    AppToast.show(context, 'Account deleted');
                  }
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                label: 'Keep my account',
                variant: ButtonVariant.ghost,
                onPressed: () => Navigator.of(sheetContext).pop(),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final AuthState authState = ref.watch(authControllerProvider);
    final User user =
        authState.user ??
        const User(
          id: 'demo',
          name: 'Demo User',
          email: 'demo@docfind.cm',
          phone: '670000000',
        );

    final ThemeMode currentThemeMode = ref.watch(themeModeProvider);
    final Locale currentLocale = ref.watch(appLocaleProvider);
    final Color avatarColor = _parseHex(user.avatarColorHex);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: isDark
            ? AppColors.darkSurface
            : AppColors.lightSurface,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go(RoutePaths.search);
            }
          },
        ),
        title: Text(
          'Profile and settings',
          style: AppTypography.heading1.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // User Header
            Row(
              children: <Widget>[
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: avatarColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    user.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        user.name,
                        style: AppTypography.heading1.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.email,
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark
                              ? AppColors.darkMuted
                              : AppColors.lightMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Avatar Color Swatches
            const _SectionTitle(title: 'Avatar colour'),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: AppColors.avatarSwatches.map((Color col) {
                final String hex =
                    '#${col.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
                final bool isSelected =
                    user.avatarColorHex.toUpperCase() == hex.toUpperCase();

                return GestureDetector(
                  onTap: () {
                    ref
                        .read(authControllerProvider.notifier)
                        .updateProfile(user.copyWith(avatarColorHex: hex));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: AppSpacing.md),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: col,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(
                              color: theme.colorScheme.onSurface,
                              width: 3,
                            )
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Personal Details
            const _SectionTitle(title: 'Personal details'),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Full name',
              style: AppTypography.heading2.copyWith(fontSize: 14),
            ),
            const SizedBox(height: AppSpacing.xs),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Your full name'),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Phone number (+237)',
              style: AppTypography.heading2.copyWith(fontSize: 14),
            ),
            const SizedBox(height: AppSpacing.xs),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(hintText: '6XX XXX XXX'),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Email', style: AppTypography.heading2.copyWith(fontSize: 14)),
            const SizedBox(height: AppSpacing.xs),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'you@email.com'),
            ),
            if (_formError != null) ...<Widget>[
              const SizedBox(height: AppSpacing.sm),
              Text(
                _formError!,
                style: TextStyle(
                  color: isDark ? AppColors.darkRed : AppColors.lightRed,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            AppButton(label: 'Save changes', onPressed: _saveProfile),
            const SizedBox(height: AppSpacing.xxl),

            // Preferences
            const _SectionTitle(title: 'Preferences'),
            const SizedBox(height: AppSpacing.sm),
            _SettingsCard(
              children: <Widget>[
                _PreferenceRow(
                  label: 'Language',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      AppChip(
                        label: 'English',
                        isSelected: currentLocale.languageCode == 'en',
                        onTap: () {
                          ref
                              .read(appLocaleProvider.notifier)
                              .setLocale(const Locale('en'));
                          AppToast.show(context, 'Language: English');
                        },
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      AppChip(
                        label: 'Français',
                        isSelected: currentLocale.languageCode == 'fr',
                        onTap: () {
                          ref
                              .read(appLocaleProvider.notifier)
                              .setLocale(const Locale('fr'));
                          AppToast.show(context, 'Langue : Français');
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(),
                _PreferenceRow(
                  label: 'Appearance',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      AppChip(
                        label: 'System',
                        isSelected: currentThemeMode == ThemeMode.system,
                        onTap: () => ref
                            .read(themeModeProvider.notifier)
                            .setThemeMode(ThemeMode.system),
                      ),
                      const SizedBox(width: 4),
                      AppChip(
                        label: 'Light',
                        isSelected: currentThemeMode == ThemeMode.light,
                        onTap: () => ref
                            .read(themeModeProvider.notifier)
                            .setThemeMode(ThemeMode.light),
                      ),
                      const SizedBox(width: 4),
                      AppChip(
                        label: 'Dark',
                        isSelected: currentThemeMode == ThemeMode.dark,
                        onTap: () => ref
                            .read(themeModeProvider.notifier)
                            .setThemeMode(ThemeMode.dark),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                _PreferenceRow(
                  label: 'Default town',
                  trailing: DropdownButton<String>(
                    value: AppTowns.searchTowns.contains(user.defaultTown)
                        ? user.defaultTown
                        : AppTowns.searchTowns.first,
                    underline: const SizedBox.shrink(),
                    items: AppTowns.searchTowns.map((String t) {
                      return DropdownMenuItem<String>(value: t, child: Text(t));
                    }).toList(),
                    onChanged: (String? val) {
                      if (val != null) {
                        ref
                            .read(authControllerProvider.notifier)
                            .updateProfile(user.copyWith(defaultTown: val));
                        AppToast.show(
                          context,
                          val == 'All towns'
                              ? 'Default town cleared'
                              : 'Default town: $val',
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Notifications
            const _SectionTitle(title: 'Notifications'),
            const SizedBox(height: AppSpacing.sm),
            _SettingsCard(
              children: <Widget>[
                _NotificationToggleRow(
                  title: 'Push alerts',
                  subtitle: 'New matches for your saved searches',
                  value: user.pushNotifications,
                  onChanged: (bool val) {
                    ref
                        .read(authControllerProvider.notifier)
                        .updateProfile(user.copyWith(pushNotifications: val));
                  },
                ),
                const Divider(),
                _NotificationToggleRow(
                  title: 'SMS alerts',
                  subtitle: 'When push is unavailable',
                  value: user.smsNotifications,
                  onChanged: (bool val) {
                    ref
                        .read(authControllerProvider.notifier)
                        .updateProfile(user.copyWith(smsNotifications: val));
                  },
                ),
                const Divider(),
                _NotificationToggleRow(
                  title: 'Email receipts',
                  subtitle: 'Copies of your reports and claims',
                  value: user.emailNotifications,
                  onChanged: (bool val) {
                    ref
                        .read(authControllerProvider.notifier)
                        .updateProfile(user.copyWith(emailNotifications: val));
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Privacy and Security
            const _SectionTitle(title: 'Privacy and security'),
            const SizedBox(height: AppSpacing.sm),
            _SettingsCard(
              children: <Widget>[
                _ActionRow(
                  label: 'Change password',
                  onTap: _showChangePasswordSheet,
                ),
                const Divider(),
                _ActionRow(
                  label: 'Download my data',
                  onTap: () {
                    AppToast.show(
                      context,
                      'We will email a copy of your data to ${user.email}',
                    );
                  },
                ),
                const Divider(),
                _ActionRow(
                  label: 'Delete my account',
                  color: isDark ? AppColors.darkRed : AppColors.lightRed,
                  onTap: _showDeleteAccountSheet,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Logout Button
            AppButton(
              label: 'Log out',
              variant: ButtonVariant.ghost,
              onPressed: _handleLogout,
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Text(
      title,
      style: AppTypography.heading2.copyWith(
        color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
        fontSize: 13,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.card,
        border: Border.all(
          color: isDark ? AppColors.darkLine : AppColors.lightLine,
        ),
      ),
      child: Column(children: children),
    );
  }
}

class _PreferenceRow extends StatelessWidget {
  const _PreferenceRow({required this.label, required this.trailing});

  final String label;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: AppTypography.heading2.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

class _NotificationToggleRow extends StatelessWidget {
  const _NotificationToggleRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: AppTypography.heading2.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          AppSwitch(
            value: value,
            onChanged: onChanged,
            semanticLabel: 'Toggle $title',
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.label, required this.onTap, this.color});

  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              label,
              style: AppTypography.heading2.copyWith(
                color: color ?? theme.colorScheme.onSurface,
                fontSize: 15,
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color:
                  color ?? theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
