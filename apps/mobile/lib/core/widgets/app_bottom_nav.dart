import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import '../theme/app_typography.dart';

enum NavTab {
  home('Home', Icons.home_rounded),
  search('Search', Icons.search_rounded),
  report('Report', Icons.add_circle_outline_rounded),
  alerts('Alerts', Icons.notifications_none_rounded);

  const NavTab(this.label, this.icon);
  final String label;
  final IconData icon;
}

/// Custom Bottom Navigation bar with sliding top active indicator and unread badge.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    required this.currentTab,
    required this.onTabSelected,
    this.unreadMessagesCount = 0,
    super.key,
  });

  final NavTab currentTab;
  final ValueChanged<NavTab> onTabSelected;
  final int unreadMessagesCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final int currentIndex = NavTab.values.indexOf(currentTab);

    final Color activeColor = isDark
        ? AppColors.darkPrimary
        : AppColors.lightPrimary;
    final Color inactiveColor = isDark
        ? AppColors.darkMuted
        : AppColors.lightMuted;
    final Color borderColor = isDark ? AppColors.darkLine : AppColors.lightLine;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: borderColor, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double tabWidth =
                  constraints.maxWidth / NavTab.values.length;
              final double indicatorWidth = tabWidth * 0.55;

              return Stack(
                children: <Widget>[
                  // Animated Top Active Indicator Bar
                  AnimatedPositioned(
                    duration: AppMotion.screenPushDuration,
                    curve: AppMotion.screenPushCurve,
                    top: 0,
                    left:
                        (currentIndex * tabWidth) +
                        ((tabWidth - indicatorWidth) / 2),
                    child: Container(
                      width: indicatorWidth,
                      height: 3,
                      decoration: BoxDecoration(
                        color: activeColor,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(3),
                        ),
                      ),
                    ),
                  ),
                  // Tabs row
                  Row(
                    children: NavTab.values.map((NavTab tab) {
                      final bool isSelected = tab == currentTab;
                      final bool showBadge = false;

                      return Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => onTabSelected(tab),
                            child: Semantics(
                              selected: isSelected,
                              label:
                                  '${tab.label}${showBadge ? ', $unreadMessagesCount unread messages' : ''}',
                              button: true,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: <Widget>[
                                      Icon(
                                        tab.icon,
                                        size: 24,
                                        color: isSelected
                                            ? activeColor
                                            : inactiveColor,
                                      ),
                                      if (showBadge)
                                        Positioned(
                                          top: -2,
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
                                  const SizedBox(height: 4),
                                  Text(
                                    tab.label,
                                    style: AppTypography.caption.copyWith(
                                      fontSize: 11,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? activeColor
                                          : inactiveColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
