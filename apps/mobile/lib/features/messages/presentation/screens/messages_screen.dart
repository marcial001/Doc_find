import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../shared/domain/entities/chat_thread.dart';
import '../controllers/messages_controller.dart';

class MessagesScreen extends ConsumerWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final AppLocalizations l10n = context.l10n;
    final MessagesState state = ref.watch(messagesControllerProvider);
    final Color primary = isDark
        ? AppColors.darkPrimary
        : AppColors.lightPrimary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          color: primary,
          onRefresh: () =>
              ref.read(messagesControllerProvider.notifier).loadThreads(),
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
                        l10n.messagesTitle,
                        style: AppTypography.displayLarge.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'You talk to the Doc-Find team. Never directly to the finder.',
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
              if (state.isLoading && state.threads.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: primary),
                  ),
                )
              else if (state.threads.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: EmptyStateWidget(
                      icon: Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: 36,
                        color: primary,
                      ),
                      title: 'No conversations yet',
                      message:
                          'When you claim or report a document, your conversation with the Doc-Find moderation team appears here.',
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
                      final ChatThread thread = state.threads[index];
                      return _ThreadCard(
                        thread: thread,
                        onTap: () {
                          ref
                              .read(messagesControllerProvider.notifier)
                              .openThread(thread.id);
                          context.push('/messages/chat/${thread.id}');
                        },
                      );
                    }, childCount: state.threads.length),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThreadCard extends StatelessWidget {
  const _ThreadCard({required this.thread, required this.onTap});

  final ChatThread thread;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color primary = isDark
        ? AppColors.darkPrimary
        : AppColors.lightPrimary;
    final String lastText =
        thread.lastMessage?.text ?? 'No messages in conversation';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.card,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.card,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: AppRadius.card,
              border: Border.all(
                color: isDark ? AppColors.darkLine : AppColors.lightLine,
                width: 1,
              ),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: primary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'DF',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkOnPrimary
                          : AppColors.lightOnPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              thread.title,
                              style: AppTypography.heading2.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (thread.unreadCount > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${thread.unreadCount}',
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.darkOnPrimary
                                      : AppColors.lightOnPrimary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lastText,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
