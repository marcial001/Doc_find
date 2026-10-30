import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/domain/entities/chat_thread.dart';
import '../controllers/messages_controller.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({required this.threadId, super.key});

  final int threadId;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(messagesControllerProvider.notifier).openThread(widget.threadId);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSend() {
    final String text = _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    ref
        .read(messagesControllerProvider.notifier)
        .sendMessage(threadId: widget.threadId, text: text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color primary = isDark
        ? AppColors.darkPrimary
        : AppColors.lightPrimary;
    final MessagesState state = ref.watch(messagesControllerProvider);
    final ChatThread? thread =
        state.activeThread ??
        state.threads
            .where((ChatThread t) => t.id == widget.threadId)
            .firstOrNull;

    if (thread != null) {
      _scrollToBottom();
    }

    final String title = thread?.title ?? 'Doc-Find Support';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: isDark
            ? AppColors.darkSurface
            : AppColors.lightSurface,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        titleSpacing: 0,
        title: Row(
          children: <Widget>[
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(color: primary, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text(
                'DF',
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkOnPrimary
                      : AppColors.lightOnPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    title,
                    style: AppTypography.heading2.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Doc-Find team · replies in minutes',
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.darkMuted
                          : AppColors.lightMuted,
                      fontSize: 12,
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
      body: Column(
        children: <Widget>[
          Expanded(
            child: thread == null
                ? Center(child: CircularProgressIndicator(color: primary))
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.lg,
                    ),
                    itemCount:
                        thread.messages.length + (state.isTyping ? 1 : 0),
                    itemBuilder: (BuildContext context, int index) {
                      if (index == thread.messages.length && state.isTyping) {
                        return const _TypingIndicatorBubble();
                      }
                      final ChatMessage message = thread.messages[index];
                      return _MessageBubble(message: message);
                    },
                  ),
          ),
          _ChatInputBar(controller: _textController, onSend: _handleSend),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bool isMe = message.isFromUser;
    final Color primary = isDark
        ? AppColors.darkPrimary
        : AppColors.lightPrimary;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 2,
        ),
        decoration: BoxDecoration(
          color: isMe
              ? primary
              : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
          borderRadius: BorderRadius.only(
            topLeft: AppRadius.cardRadius,
            topRight: AppRadius.cardRadius,
            bottomLeft: Radius.circular(isMe ? AppRadius.cardValue : 4),
            bottomRight: Radius.circular(isMe ? 4 : AppRadius.cardValue),
          ),
          border: isMe
              ? null
              : Border.all(
                  color: isDark ? AppColors.darkLine : AppColors.lightLine,
                  width: 1,
                ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          message.text,
          style: AppTypography.bodyMedium.copyWith(
            color: isMe
                ? (isDark ? AppColors.darkOnPrimary : AppColors.lightOnPrimary)
                : theme.colorScheme.onSurface,
            height: 1.35,
          ),
        ),
      ),
    );
  }
}

class _TypingIndicatorBubble extends StatefulWidget {
  const _TypingIndicatorBubble();

  @override
  State<_TypingIndicatorBubble> createState() => _TypingIndicatorBubbleState();
}

class _TypingIndicatorBubbleState extends State<_TypingIndicatorBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color primary = isDark
        ? AppColors.darkPrimary
        : AppColors.lightPrimary;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 4,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: const BorderRadius.only(
            topLeft: AppRadius.cardRadius,
            topRight: AppRadius.cardRadius,
            bottomLeft: Radius.circular(4),
            bottomRight: AppRadius.cardRadius,
          ),
          border: Border.all(
            color: isDark ? AppColors.darkLine : AppColors.lightLine,
          ),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List<Widget>.generate(3, (int i) {
                final double t = (_controller.value + (i * 0.2)) % 1.0;
                final double dy = -4.0 * (1.0 - (2.0 * t - 1.0).abs());
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                  transform: Matrix4.translationValues(0, dy, 0),
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: primary,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  const _ChatInputBar({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color primary = isDark
        ? AppColors.darkPrimary
        : AppColors.lightPrimary;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.sm + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkLine : AppColors.lightLine,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: controller,
              style: AppTypography.bodyMedium.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              decoration: const InputDecoration(
                hintText: 'Write a message',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          IconButton(
            onPressed: onSend,
            style: IconButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: isDark
                  ? AppColors.darkOnPrimary
                  : AppColors.lightOnPrimary,
              padding: const EdgeInsets.all(10),
            ),
            icon: const Icon(Icons.send_rounded, size: 20),
          ),
        ],
      ),
    );
  }
}
