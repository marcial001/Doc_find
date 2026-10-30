import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/repositories/report_repository.dart';
import '../controllers/report_controller.dart';

class ReportScreen extends ConsumerWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final ReportState state = ref.watch(reportControllerProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
          onRefresh: () =>
              ref.read(reportControllerProvider.notifier).loadMyReports(),
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
                        'I found a\ndocument',
                        style: AppTypography.displayLarge.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontSize: 28,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Report it in three steps. Our team checks it before anything goes public.',
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDark
                              ? AppColors.darkMuted
                              : AppColors.lightMuted,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      // Privacy assurance banner
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkGreenTint
                              : AppColors.lightGreenTint,
                          borderRadius: AppRadius.card,
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkLine
                                : AppColors.lightLine,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text('🔒', style: TextStyle(fontSize: 18)),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                'The full document is never shown to the public. We blur the photo and hide the ID number.',
                                style: AppTypography.bodySmall.copyWith(
                                  color: isDark
                                      ? AppColors.darkInk
                                      : AppColors.lightInk,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppButton(
                        label: 'Start report',
                        onPressed: () {
                          ref
                              .read(reportControllerProvider.notifier)
                              .startNewReport();
                          context.push('/report/flow');
                        },
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      Text(
                        'Your recent reports',
                        style: AppTypography.heading2.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                  ),
                ),
              ),
              if (state.myReports.isEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurface
                            : AppColors.lightSurface,
                        borderRadius: AppRadius.card,
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkLine
                              : AppColors.lightLine,
                        ),
                      ),
                      child: Text(
                        'No reports yet. Thank you for being honest enough to be here.',
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDark
                              ? AppColors.darkMuted
                              : AppColors.lightMuted,
                        ),
                        textAlign: TextAlign.center,
                      ),
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
                      final ReportedDocument report = state.myReports[index];
                      return _ReportCard(report: report);
                    }, childCount: state.myReports.length),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({required this.report});

  final ReportedDocument report;

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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkGreenTint
                          : AppColors.lightGreenTint,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      report.type.label,
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkPrimary
                            : AppColors.lightPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    report.town,
                    style: AppTypography.heading2.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    report.spot,
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF5B700).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'In review',
                style: TextStyle(
                  color: Color(0xFF8A6500),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
