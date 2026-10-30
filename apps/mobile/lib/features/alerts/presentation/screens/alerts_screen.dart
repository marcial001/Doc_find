import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_switch.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../shared/domain/entities/search_alert.dart';
import '../controllers/alerts_controller.dart';

class AlertsScreen extends ConsumerWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final AppLocalizations l10n = context.l10n;
    final AlertsState state = ref.watch(alertsControllerProvider);
    final Color primary = isDark
        ? AppColors.darkPrimary
        : AppColors.lightPrimary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          color: primary,
          onRefresh: () =>
              ref.read(alertsControllerProvider.notifier).loadAlerts(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        l10n.alertsTitle,
                        style: AppTypography.displayLarge.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'We notify you when a matching document is posted.',
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDark
                              ? AppColors.darkMuted
                              : AppColors.lightMuted,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  ),
                ),
              ),
              if (state.isLoading && state.alerts.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: primary),
                  ),
                )
              else if (state.alerts.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: EmptyStateWidget(
                      icon: Icon(
                        Icons.notifications_none_rounded,
                        size: 36,
                        color: primary,
                      ),
                      title: 'No saved alerts',
                      message:
                          'Tap "Alert me for this search" on the search page to receive alerts when a matching document is posted.',
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((
                      BuildContext context,
                      int index,
                    ) {
                      final SearchAlert alert = state.alerts[index];
                      return _AlertCard(
                        alert: alert,
                        onToggle: (bool val) {
                          ref
                              .read(alertsControllerProvider.notifier)
                              .toggleAlert(alert.id);
                        },
                      );
                    }, childCount: state.alerts.length),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.alert, required this.onToggle});

  final SearchAlert alert;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: AppRadius.card,
          border: Border.all(
            color: isDark ? AppColors.darkLine : AppColors.lightLine,
            width: 1,
          ),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    alert.label,
                    style: AppTypography.heading2.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    alert.isEnabled ? 'Push + SMS when posted' : 'Paused',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.darkMuted
                          : AppColors.lightMuted,
                    ),
                  ),
                ],
              ),
            ),
            AppSwitch(
              value: alert.isEnabled,
              onChanged: onToggle,
              semanticLabel: 'Toggle alert for ${alert.label}',
            ),
          ],
        ),
      ),
    );
  }
}
