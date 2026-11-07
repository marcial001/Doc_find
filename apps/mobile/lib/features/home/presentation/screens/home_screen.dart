import 'dart:async';
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
import '../../../../core/widgets/app_sheet.dart';
import '../../../../core/widgets/redacted_doc.dart';
import '../../../../shared/domain/entities/listing.dart';
import '../../../messages/presentation/controllers/messages_controller.dart';
import '../../../search/presentation/controllers/search_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController _carouselController = PageController(
    viewportFraction: 0.92,
  );
  int _currentCarouselIndex = 0;
  Timer? _autoPlayTimer;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 6), (Timer timer) {
      if (!mounted) return;
      if (_carouselController.hasClients) {
        final int next = (_currentCarouselIndex + 1) % 4;
        _carouselController.animateToPage(
          next,
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _carouselController.dispose();
    super.dispose();
  }

  void _showPrivacyLawSheet(BuildContext context) {
    AppSheet.show<void>(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.lightGreenTint,
              borderRadius: AppRadius.md,
              border: Border.all(color: AppColors.lightPrimary),
            ),
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.verified_user_rounded,
                  color: AppColors.lightPrimary,
                  size: 24,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Certified Personal Data Protection',
                    style: AppTypography.heading2.copyWith(
                      color: AppColors.lightPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Cameroon Law No. 2024/017',
            style: AppTypography.heading1.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'In accordance with Cameroon Law No. 2024/017 on the Protection of Personal Data:\n\n'
            '• Public masking: Identity numbers, full dates of birth, and sensitive document fields are masked with cryptographic obscuration prior to any public listing.\n'
            '• Dual explicit consent: Finders and claimants must explicitly consent to location and contact sharing before submission.\n'
            '• Strict audit trail: Any admin unmasking action is logged with timestamp, administrator ID, and justification.',
            style: AppTypography.bodySmall.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: 'Understood',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final searchFeed = ref.watch(searchControllerProvider);
    final messagesState = ref.watch(messagesControllerProvider);
    final int unreadAdmin = messagesState.totalUnread;

    return Stack(
      children: <Widget>[
        // Main scrollable content
        SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: AppSpacing.md),

              // 1. Hero 4-Slide Interactive Carousel
              _buildHeroCarousel(context, isDark),

              const SizedBox(height: AppSpacing.sm),

              // Carousel Dot Indicators
              _buildCarouselIndicators(isDark),

              const SizedBox(height: AppSpacing.lg),

              // 2. Quick Action Bar (Thumb-Zone Ergonomics)
              _buildQuickActions(context, isDark),

              const SizedBox(height: AppSpacing.xl),

              // 3. National Impact Metrics Bar
              _buildMetricsBar(context, isDark),

              const SizedBox(height: AppSpacing.xl),

              // 4. Recently Reported Documents Preview
              _buildRecentFeed(context, isDark, searchFeed.listings),

              const SizedBox(height: AppSpacing.xl),

              // 5. Law No. 2024/017 Compliance Card
              _buildComplianceCard(context, isDark),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),

        // 2. Floating Admin Chat Button (Direct support with Admin)
        Positioned(
          bottom: AppSpacing.md,
          right: AppSpacing.md,
          child: _buildFloatingAdminChatButton(context, isDark, unreadAdmin),
        ),
      ],
    );
  }

  Widget _buildHeroCarousel(BuildContext context, bool isDark) {
    final slides = <_HeroSlideData>[
      _HeroSlideData(
        tag: 'NATIONAL SERVICE',
        title: context.l10n.homeHeroTitle1,
        subtitle: context.l10n.homeHeroSub1,
        actionLabel: context.l10n.homeHeroAction1,
        actionIcon: Icons.search_rounded,
        icon: Icons.document_scanner_rounded,
        gradientStart: const Color(0xFF0F4A2C),
        gradientEnd: const Color(0xFF1F6B42),
        onAction: () => context.go(RoutePaths.search),
      ),
      _HeroSlideData(
        tag: 'CAMEROON LAW NO. 2024/017',
        title: context.l10n.homeHeroTitle2,
        subtitle: context.l10n.homeHeroSub2,
        actionLabel: context.l10n.homeHeroAction2,
        actionIcon: Icons.shield_rounded,
        icon: Icons.security_rounded,
        gradientStart: const Color(0xFF0C3E3A),
        gradientEnd: const Color(0xFF165D55),
        onAction: () => _showPrivacyLawSheet(context),
      ),
      _HeroSlideData(
        tag: 'VERIFIED RESTITUTION',
        title: context.l10n.homeHeroTitle3,
        subtitle: context.l10n.homeHeroSub3,
        actionLabel: context.l10n.homeHeroAction3,
        actionIcon: Icons.add_circle_outline_rounded,
        icon: Icons.handshake_rounded,
        gradientStart: const Color(0xFF154832),
        gradientEnd: const Color(0xFF27724E),
        onAction: () => context.push(RoutePaths.reportFlow),
      ),
      _HeroSlideData(
        tag: 'REAL-TIME ALERTS',
        title: context.l10n.homeHeroTitle4,
        subtitle: context.l10n.homeHeroSub4,
        actionLabel: context.l10n.homeHeroAction4,
        actionIcon: Icons.notifications_active_rounded,
        icon: Icons.location_on_rounded,
        gradientStart: const Color(0xFF1A3F2C),
        gradientEnd: const Color(0xFF2A6644),
        onAction: () => context.go(RoutePaths.alerts),
      ),
    ];

    return SizedBox(
      height: 236,
      child: PageView.builder(
        controller: _carouselController,
        physics: const ClampingScrollPhysics(),
        onPageChanged: (int index) {
          setState(() => _currentCarouselIndex = index);
        },
        itemCount: slides.length,
        itemBuilder: (BuildContext context, int index) {
          final slide = slides[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: AppRadius.card,
                gradient: LinearGradient(
                  colors: <Color>[slide.gradientStart, slide.gradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: slide.gradientStart.withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                children: <Widget>[
                  // Subtle geometric background watermark
                  Positioned(
                    right: -16,
                    bottom: -16,
                    child: Icon(
                      slide.icon,
                      size: 140,
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),

                  // Slide content
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Tag pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: AppRadius.pill,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.28),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                slide.icon,
                                color: AppColors.lightSun,
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                slide.tag,
                                style: AppTypography.caption.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 10,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Title
                        Text(
                          slide.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.heading1.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            height: 1.25,
                          ),
                        ),

                        const SizedBox(height: 6),

                        // Subtitle
                        Expanded(
                          child: Text(
                            slide.subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.bodySmall.copyWith(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 12.5,
                              height: 1.35,
                            ),
                          ),
                        ),

                        // Call-to-action button
                        GestureDetector(
                          onTap: slide.onAction,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: AppRadius.pill,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  slide.actionLabel,
                                  style: AppTypography.button.copyWith(
                                    color: slide.gradientStart,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(
                                  slide.actionIcon,
                                  color: slide.gradientStart,
                                  size: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCarouselIndicators(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (int index) {
        final bool isActive = index == _currentCarouselIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          width: isActive ? 22 : 6,
          decoration: BoxDecoration(
            color: isActive
                ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                : (isDark ? AppColors.darkLine : AppColors.lightLine),
            borderRadius: AppRadius.pill,
          ),
        );
      }),
    );
  }

  Widget _buildQuickActions(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _buildActionTile(
              context: context,
              icon: Icons.search_rounded,
              title: context.l10n.homeQuickSearch,
              color: AppColors.lightPrimary,
              isDark: isDark,
              onTap: () => context.go(RoutePaths.search),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _buildActionTile(
              context: context,
              icon: Icons.add_circle_rounded,
              title: context.l10n.homeQuickReport,
              color: const Color(0xFF1E7E52),
              isDark: isDark,
              onTap: () => context.push(RoutePaths.reportFlow),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _buildActionTile(
              context: context,
              icon: Icons.notifications_active_rounded,
              title: context.l10n.homeQuickAlerts,
              color: AppColors.lightSun,
              iconColor: Colors.black87,
              isDark: isDark,
              onTap: () => context.go(RoutePaths.alerts),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    final theme = Theme.of(context);
    return Material(
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      borderRadius: AppRadius.md,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.md,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: AppRadius.md,
            border: Border.all(
              color: isDark ? AppColors.darkLine : AppColors.lightLine,
              width: 1,
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: iconColor ?? color, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 11.5,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricsBar(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: AppRadius.md,
          border: Border.all(
            color: isDark ? AppColors.darkLine : AppColors.lightLine,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildMetricItem(
              context: context,
              number: '1,240+',
              label: 'Recovered',
              icon: Icons.check_circle_outline_rounded,
              color: AppColors.lightPrimary,
            ),
            Container(
              height: 36,
              width: 1,
              color: isDark ? AppColors.darkLine : AppColors.lightLine,
            ),
            _buildMetricItem(
              context: context,
              number: '10',
              label: 'Regions',
              icon: Icons.map_outlined,
              color: const Color(0xFF1E7E52),
            ),
            Container(
              height: 36,
              width: 1,
              color: isDark ? AppColors.darkLine : AppColors.lightLine,
            ),
            _buildMetricItem(
              context: context,
              number: '100%',
              label: 'Compliant',
              icon: Icons.verified_rounded,
              color: AppColors.lightPrimary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem({
    required BuildContext context,
    required String number,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(
              number,
              style: AppTypography.heading2.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            fontSize: 11,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkMuted
                : AppColors.lightMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentFeed(
    BuildContext context,
    bool isDark,
    List<Listing> listings,
  ) {
    final theme = Theme.of(context);
    final recentListings = listings.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                context.l10n.homeRecentDocs,
                style: AppTypography.heading2.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              GestureDetector(
                onTap: () => context.go(RoutePaths.search),
                child: Text(
                  context.l10n.homeViewAll,
                  style: AppTypography.caption.copyWith(
                    color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 168,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            itemCount: recentListings.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (BuildContext context, int index) {
              final item = recentListings[index];
              return Container(
                width: 160,
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: AppRadius.md,
                  border: Border.all(
                    color: isDark ? AppColors.darkLine : AppColors.lightLine,
                  ),
                ),
                child: InkWell(
                  onTap: () => context.push('/detail/${item.id}'),
                  borderRadius: AppRadius.md,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: RedactedDoc(
                          type: item.type,
                          width: 136,
                          height: 78,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: <Widget>[
                          const Icon(
                            Icons.location_on_outlined,
                            size: 12,
                            color: AppColors.lightPrimary,
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              item.town,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.caption.copyWith(
                                fontSize: 10.5,
                                color: isDark
                                    ? AppColors.darkMuted
                                    : AppColors.lightMuted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildComplianceCard(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkGreenTint : AppColors.lightGreenTint,
          borderRadius: AppRadius.md,
          border: Border.all(
            color: isDark
                ? AppColors.darkPrimary.withValues(alpha: 0.3)
                : AppColors.lightPrimary.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.gavel_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Law No. 2024/017 Compliant',
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.darkPrimary
                          : AppColors.lightPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    context.l10n.homeTrustBadge,
                    style: AppTypography.caption.copyWith(
                      fontSize: 11,
                      color: isDark
                          ? Colors.white70
                          : const Color(0xFF2E6347),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingAdminChatButton(
    BuildContext context,
    bool isDark,
    int unreadCount,
  ) {
    return Semantics(
      button: true,
      label: 'Chat directly with Doc-Find Admin',
      child: Material(
        elevation: 6,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        borderRadius: AppRadius.pill,
        color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
        child: InkWell(
          onTap: () {
            // Open direct chat exclusively with Admin (threadId: 0)
            context.push('/messages/chat/0');
          },
          borderRadius: AppRadius.pill,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: AppRadius.pill,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    const Icon(
                      Icons.support_agent_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                    if (unreadCount > 0)
                      Positioned(
                        top: -3,
                        right: -3,
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
                const SizedBox(width: 8),
                Text(
                  context.l10n.homeChatAdmin,
                  style: AppTypography.button.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroSlideData {
  const _HeroSlideData({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.actionIcon,
    required this.icon,
    required this.gradientStart,
    required this.gradientEnd,
    required this.onAction,
  });

  final String tag;
  final String title;
  final String subtitle;
  final String actionLabel;
  final IconData actionIcon;
  final IconData icon;
  final Color gradientStart;
  final Color gradientEnd;
  final VoidCallback onAction;
}
