import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/redacted_doc.dart';
import '../../../../shared/domain/entities/listing.dart';
import '../../../claim/presentation/sheets/claim_sheet.dart';
import '../../../search/presentation/controllers/search_controller.dart' as sc;

class ListingDetailScreen extends ConsumerWidget {
  const ListingDetailScreen({required this.listingId, super.key});

  final int listingId;

  String _formatWhen(int days) {
    if (days == 0) return 'Today';
    if (days == 1) return 'Yesterday';
    return '$days days ago';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final sc.SearchFeedState searchState = ref.watch(
      sc.searchControllerProvider,
    );

    final Listing? listing = searchState.listings.cast<Listing?>().firstWhere(
      (Listing? l) => l?.id == listingId,
      orElse: () => null,
    );

    if (listing == null) {
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.detailTitle)),
        body: const Center(
          child: Text('Document not found', style: AppTypography.bodyMedium),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          context.l10n.detailTitle,
          style: AppTypography.heading1.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Large Redacted Document Illustration
                  Center(child: RedactedDoc(type: listing.type, isLarge: true)),
                  const SizedBox(height: AppSpacing.xl),
                  // Partial Name Title
                  Text(
                    listing.name,
                    style: AppTypography.displayLarge.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontSize: 26,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Document Type Tag
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: listing.type.color.withValues(alpha: 0.12),
                        borderRadius: AppRadius.pill,
                      ),
                      child: Text(
                        listing.type.label,
                        style: AppTypography.caption.copyWith(
                          color: listing.type.color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Detail Information Rows Card
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: AppRadius.card,
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkLine
                            : AppColors.lightLine,
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        _DetailRow(
                          label: context.l10n.detailFoundIn,
                          value: listing.town,
                        ),
                        const Divider(height: 1),
                        _DetailRow(
                          label: context.l10n.detailPlace,
                          value: listing.spot,
                        ),
                        const Divider(height: 1),
                        _DetailRow(
                          label: context.l10n.detailDate,
                          value: _formatWhen(listing.daysAgo),
                        ),
                        if (listing.note.isNotEmpty) ...<Widget>[
                          const Divider(height: 1),
                          _DetailRow(
                            label: context.l10n.detailNote,
                            value: listing.note,
                          ),
                        ],
                        const Divider(height: 1),
                        _DetailRow(
                          label: context.l10n.detailStatus,
                          value: context.l10n.detailHeldSafely,
                          valueColor: isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary,
                          icon: Icons.shield_outlined,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Privacy Notice Box
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1B2820)
                          : const Color(0xFFEBF1ED),
                      borderRadius: AppRadius.sm,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.lock_outline_rounded,
                          size: 18,
                          color: isDark
                              ? AppColors.darkMuted
                              : AppColors.lightMuted,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            context.l10n.detailPrivacyNote,
                            style: AppTypography.caption.copyWith(
                              color: isDark
                                  ? AppColors.darkMuted
                                  : AppColors.lightMuted,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Sticky CTA Footer
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.darkLine : AppColors.lightLine,
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: AppButton(
                label: context.l10n.detailClaimCTA,
                onPressed: () {
                  ClaimSheet.show(
                    context: context,
                    listing: listing,
                    onClaimSuccess: () {
                      context.go(RoutePaths.messages);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.icon,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (icon != null) ...<Widget>[
                  Icon(icon, size: 16, color: valueColor),
                  const SizedBox(width: 4),
                ],
                Flexible(
                  child: Text(
                    value,
                    textAlign: TextAlign.end,
                    style: AppTypography.bodySmall.copyWith(
                      color: valueColor ?? theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
