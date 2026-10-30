import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/document_types.dart';
import '../../../../core/constants/towns.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/debouncer.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/doc_card.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../shared/domain/entities/listing.dart';
import '../controllers/search_controller.dart' as sc;

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _queryController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Debouncer _debouncer = Debouncer(
    duration: const Duration(milliseconds: 300),
  );

  @override
  void dispose() {
    _queryController.dispose();
    _scrollController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _onQueryChanged(String val) {
    _debouncer.run(() {
      ref.read(sc.searchControllerProvider.notifier).updateQuery(val);
      _resetScroll();
    });
  }

  void _resetScroll() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  void _onAlertMe() {
    final state = ref.read(sc.searchControllerProvider);
    final String typeName = state.filters.selectedType?.label ?? 'Any document';
    final String town = state.filters.selectedTown;
    AppToast.show(context, 'Alert saved for $typeName in $town');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final sc.SearchFeedState searchState = ref.watch(
      sc.searchControllerProvider,
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(sc.searchControllerProvider.notifier).performSearch(),
        color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[
            // Search Header Controls
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.base,
                  AppSpacing.lg,
                  AppSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      context.l10n.searchTitle,
                      style: AppTypography.displayLarge.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Search Input with search icon & clear button
                    TextField(
                      controller: _queryController,
                      onChanged: _onQueryChanged,
                      decoration: InputDecoration(
                        hintText: context.l10n.searchPlaceholder,
                        prefixIcon: const Icon(Icons.search_rounded, size: 22),
                        suffixIcon: _queryController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 18),
                                onPressed: () {
                                  _queryController.clear();
                                  _onQueryChanged('');
                                },
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Document-Type Filter Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      child: Row(
                        children: <Widget>[
                          AppChip(
                            label: context.l10n.searchAllTypes,
                            isSelected:
                                searchState.filters.selectedType == null,
                            onTap: () {
                              ref
                                  .read(sc.searchControllerProvider.notifier)
                                  .selectType(null);
                              _resetScroll();
                            },
                          ),
                          ...DocumentType.values.map((DocumentType dt) {
                            final bool isSelected =
                                searchState.filters.selectedType == dt;
                            return Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: AppChip(
                                label: dt.label,
                                isSelected: isSelected,
                                badge: dt.badge,
                                badgeColor: dt.color,
                                onTap: () {
                                  ref
                                      .read(
                                        sc.searchControllerProvider.notifier,
                                      )
                                      .selectType(isSelected ? null : dt);
                                  _resetScroll();
                                },
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Dropdowns Row: Town + Date Range
                    Row(
                      children: <Widget>[
                        // Town Dropdown
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1B2820)
                                  : const Color(0xFFF0F4F1),
                              borderRadius: AppRadius.button,
                              border: Border.all(
                                color: isDark
                                    ? AppColors.darkLine
                                    : AppColors.lightLine,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: searchState.filters.selectedTown,
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 20,
                                ),
                                style: AppTypography.bodySmall.copyWith(
                                  color: theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                                dropdownColor: theme.colorScheme.surface,
                                items: AppTowns.searchTowns.map((String town) {
                                  return DropdownMenuItem<String>(
                                    value: town,
                                    child: Text(town),
                                  );
                                }).toList(),
                                onChanged: (String? val) {
                                  if (val != null) {
                                    ref
                                        .read(
                                          sc.searchControllerProvider.notifier,
                                        )
                                        .selectTown(val);
                                    _resetScroll();
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        // Date Range Dropdown
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1B2820)
                                  : const Color(0xFFF0F4F1),
                              borderRadius: AppRadius.button,
                              border: Border.all(
                                color: isDark
                                    ? AppColors.darkLine
                                    : AppColors.lightLine,
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: searchState.filters.selectedDateRange,
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 20,
                                ),
                                style: AppTypography.bodySmall.copyWith(
                                  color: theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                                dropdownColor: theme.colorScheme.surface,
                                items:
                                    <String>[
                                      context.l10n.searchAnyDate,
                                      context.l10n.searchLast7Days,
                                      context.l10n.searchLast30Days,
                                    ].map((String d) {
                                      return DropdownMenuItem<String>(
                                        value: d,
                                        child: Text(d),
                                      );
                                    }).toList(),
                                onChanged: (String? val) {
                                  if (val != null) {
                                    ref
                                        .read(
                                          sc.searchControllerProvider.notifier,
                                        )
                                        .selectDateRange(val);
                                    _resetScroll();
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Results count & "Alert me for this search" action
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          context.l10n.searchResultsCount(
                            searchState.listings.length,
                          ),
                          style: AppTypography.caption.copyWith(
                            color: isDark
                                ? AppColors.darkMuted
                                : AppColors.lightMuted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _onAlertMe,
                          icon: const Icon(
                            Icons.notifications_active_outlined,
                            size: 16,
                          ),
                          label: Text(
                            context.l10n.searchAlertMe,
                            style: AppTypography.caption.copyWith(
                              color: isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.lightPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Listings or Skeletons or Empty State
            if (searchState.isLoading)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) => AppSkeleton.card(),
                    childCount: 4,
                  ),
                ),
              )
            else if (searchState.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyStateWidget(
                  title: context.l10n.searchEmptyTitle,
                  message: context.l10n.searchEmptyBody,
                  actionLabel: context.l10n.searchAlertMe,
                  onAction: _onAlertMe,
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((
                    BuildContext context,
                    int index,
                  ) {
                    final Listing item = searchState.listings[index];
                    return DocCard(
                      id: item.id,
                      type: item.type,
                      name: item.name,
                      town: item.town,
                      spot: item.spot,
                      daysAgo: item.daysAgo,
                      animationIndex: index,
                      onTap: () {
                        context.push(
                          RoutePaths.detail.replaceFirst(':id', '${item.id}'),
                        );
                      },
                    );
                  }, childCount: searchState.listings.length),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
