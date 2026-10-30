import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/result.dart';
import '../../../../shared/domain/entities/chat_thread.dart';
import '../../data/datasources/mock_messages_datasource.dart';
import '../../data/repositories/messages_repository_impl.dart';

final Provider<MockMessagesDataSource> mockMessagesDataSourceProvider =
    Provider<MockMessagesDataSource>((Ref ref) => MockMessagesDataSource());

final Provider<MessagesRepositoryImpl> messagesRepositoryProvider =
    Provider<MessagesRepositoryImpl>((Ref ref) {
      final MockMessagesDataSource ds = ref.watch(
        mockMessagesDataSourceProvider,
      );
      return MessagesRepositoryImpl(ds);
    });

class MessagesState {
  const MessagesState({
    this.threads = const <ChatThread>[],
    this.isLoading = false,
    this.activeThread,
    this.isTyping = false,
    this.errorMessage,
  });

  final List<ChatThread> threads;
  final bool isLoading;
  final ChatThread? activeThread;
  final bool isTyping;
  final String? errorMessage;

  int get totalUnread =>
      threads.fold<int>(0, (int sum, ChatThread t) => sum + t.unreadCount);

  MessagesState copyWith({
    List<ChatThread>? threads,
    bool? isLoading,
    ChatThread? Function()? activeThread,
    bool? isTyping,
    String? Function()? errorMessage,
  }) {
    return MessagesState(
      threads: threads ?? this.threads,
      isLoading: isLoading ?? this.isLoading,
      activeThread: activeThread != null ? activeThread() : this.activeThread,
      isTyping: isTyping ?? this.isTyping,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}

class MessagesController extends StateNotifier<MessagesState> {
  MessagesController(this._repository) : super(const MessagesState()) {
    loadThreads();
  }

  final MessagesRepositoryImpl _repository;
  Timer? _typingTimer;

  Future<void> loadThreads() async {
    state = state.copyWith(isLoading: true, errorMessage: () => null);
    final Result<List<ChatThread>> result = await _repository.getThreads();
    result.when(
      success: (List<ChatThread> threads) {
        state = state.copyWith(threads: threads, isLoading: false);
      },
      failure: (f) {
        state = state.copyWith(isLoading: false, errorMessage: () => f.message);
      },
    );
  }

  Future<void> openThread(int id) async {
    final Result<ChatThread> result = await _repository.getThreadById(id);
    result.when(
      success: (ChatThread thread) {
        state = state.copyWith(activeThread: () => thread);
        markAsRead(id);
      },
      failure: (f) {
        state = state.copyWith(errorMessage: () => f.message);
      },
    );
  }

  Future<void> markAsRead(int threadId) async {
    final Result<ChatThread> result = await _repository.markAsRead(threadId);
    if (result.isSuccess) {
      final ChatThread updated = (result as Success<ChatThread>).data;
      final List<ChatThread> list = state.threads.map((ChatThread t) {
        return t.id == threadId ? updated : t;
      }).toList();
      state = state.copyWith(threads: list, activeThread: () => updated);
    }
  }

  Future<void> sendMessage({
    required int threadId,
    required String text,
    String? town,
  }) async {
    final String trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final Result<ChatThread> result = await _repository.sendMessage(
      threadId: threadId,
      text: trimmed,
    );

    if (result.isSuccess) {
      final ChatThread updated = (result as Success<ChatThread>).data;
      final List<ChatThread> list = state.threads.map((ChatThread t) {
        return t.id == threadId ? updated : t;
      }).toList();

      state = state.copyWith(
        threads: list,
        activeThread: () => updated,
        isTyping: true,
      );

      // Simulate team auto-response after 1.4s
      _typingTimer?.cancel();
      _typingTimer = Timer(const Duration(milliseconds: 1400), () async {
        final ChatMessage reply = await _repository.generateAutoReply(
          threadId,
          town: town,
        );
        final ChatThread withReply = updated.copyWith(
          messages: <ChatMessage>[...updated.messages, reply],
        );

        final List<ChatThread> finalList = state.threads.map((ChatThread t) {
          return t.id == threadId ? withReply : t;
        }).toList();

        state = state.copyWith(
          threads: finalList,
          activeThread: () => withReply,
          isTyping: false,
        );
      });
    }
  }

  Future<ChatThread?> createClaimThread({
    required int listingId,
    required String listingTitle,
    required String town,
    required String claimAnswer,
    bool hasIdPhoto = false,
  }) async {
    final Result<ChatThread> result = await _repository.createClaimThread(
      listingId: listingId,
      listingTitle: listingTitle,
      town: town,
      claimAnswer: claimAnswer,
      hasIdPhoto: hasIdPhoto,
    );

    if (result.isSuccess) {
      final ChatThread thread = (result as Success<ChatThread>).data;
      final bool alreadyExists = state.threads.any(
        (ChatThread t) => t.id == thread.id,
      );
      final List<ChatThread> list = alreadyExists
          ? state.threads
          : <ChatThread>[thread, ...state.threads];

      state = state.copyWith(threads: list, activeThread: () => thread);
      return thread;
    }
    return null;
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    super.dispose();
  }
}

final StateNotifierProvider<MessagesController, MessagesState>
messagesControllerProvider =
    StateNotifierProvider<MessagesController, MessagesState>((Ref ref) {
      final MessagesRepositoryImpl repo = ref.watch(messagesRepositoryProvider);
      return MessagesController(repo);
    });
