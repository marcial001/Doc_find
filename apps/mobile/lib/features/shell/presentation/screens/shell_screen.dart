import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../messages/presentation/controllers/messages_controller.dart';

class ShellScreen extends ConsumerWidget {
  const ShellScreen({
    required this.child,
    required this.currentTab,
    this.unreadMessagesCount,
    super.key,
  });

  final Widget child;
  final NavTab currentTab;
  final int? unreadMessagesCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final authState = ref.watch(authControllerProvider);
    final messagesState = ref.watch(messagesControllerProvider);
    final user = authState.user;
    final int unreadCount = unreadMessagesCount ?? messagesState.totalUnread;

    Color avatarColor = AppColors.lightPrimary;
    if (user != null && user.avatarColorHex.isNotEmpty) {
      try {
        final String hex = user.avatarColorHex.replaceAll('#', '');
        avatarColor = Color(int.parse('FF$hex', radix: 16));
      } catch (_) {}
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          bottom: false,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.darkLine : AppColors.lightLine,
                  width: 0.8,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Brand mark + Title
                Row(
                  children: <Widget>[
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkPrimary
                            : AppColors.lightPrimary,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.document_scanner_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      context.l10n.appName,
                      style: AppTypography.heading1.copyWith(
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                // Icons: Messages Bell with unread dot + Avatar
                Row(
                  children: <Widget>[
                    // Bell icon button
                    IconButton(
                      icon: Stack(
                        clipBehavior: Clip.none,
                        children: <Widget>[
                          Icon(
                            Icons.notifications_none_rounded,
                            size: 24,
                            color: theme.colorScheme.onSurface,
                          ),
                          if (unreadCount > 0)
                            Positioned(
                              top: 2,
                              right: 2,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.lightRed,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                      onPressed: () => context.go(RoutePaths.messages),
                      tooltip: context.l10n.navMessages,
                    ),
                    const SizedBox(width: 4),
                    // Avatar Button
                    GestureDetector(
                      onTap: () => context.go(RoutePaths.profile),
                      child: Semantics(
                        button: true,
                        label: 'Profile and settings',
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: avatarColor,
                            shape: BoxShape.circle,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: avatarColor.withValues(alpha: 0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            user?.initials ?? 'DF',
                            style: AppTypography.caption.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: child,
      bottomNavigationBar: AppBottomNav(
        currentTab: currentTab,
        unreadMessagesCount: unreadCount,
        onTabSelected: (NavTab tab) {
          switch (tab) {
            case NavTab.search:
              context.go(RoutePaths.search);
              break;
            case NavTab.report:
              context.go(RoutePaths.report);
              break;
            case NavTab.messages:
              context.go(RoutePaths.messages);
              break;
            case NavTab.alerts:
              context.go(RoutePaths.alerts);
              break;
          }
        },
      ),
    );
  }
}
