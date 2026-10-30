import 'dart:async';
import '../../../../shared/data/datasources/mock_seed_data.dart';
import '../../../../shared/domain/entities/chat_thread.dart';

class MockMessagesDataSource {
  MockMessagesDataSource() {
    _threads = List<ChatThread>.from(MockSeedData.threads);
  }

  late final List<ChatThread> _threads;

  Future<List<ChatThread>> getThreads() async {
    await Future<void>.delayed(const Duration(milliseconds: 60));
    return List<ChatThread>.unmodifiable(_threads);
  }

  Future<ChatThread> getThreadById(int id) async {
    await Future<void>.delayed(const Duration(milliseconds: 40));
    return _threads.firstWhere((ChatThread t) => t.id == id);
  }

  Future<ChatThread> markAsRead(int threadId) async {
    final int index = _threads.indexWhere((ChatThread t) => t.id == threadId);
    if (index != -1) {
      _threads[index] = _threads[index].copyWith(unreadCount: 0);
      return _threads[index];
    }
    throw Exception('Thread not found');
  }

  Future<ChatThread> sendMessage({
    required int threadId,
    required String text,
  }) async {
    final int index = _threads.indexWhere((ChatThread t) => t.id == threadId);
    if (index == -1) {
      throw Exception('Thread not found');
    }

    final ChatMessage userMsg = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      isFromUser: true,
      text: text,
      timestamp: DateTime.now(),
    );

    final List<ChatMessage> updatedMessages = <ChatMessage>[
      ..._threads[index].messages,
      userMsg,
    ];

    _threads[index] = _threads[index].copyWith(
      messages: updatedMessages,
      unreadCount: 0,
    );
    return _threads[index];
  }

  Future<ChatMessage> generateAutoReply(int threadId, {String? town}) async {
    final int index = _threads.indexWhere((ChatThread t) => t.id == threadId);
    if (index == -1) {
      throw Exception('Thread not found');
    }

    final bool isClaim = _threads[index].listingId != null;
    final String replyText = isClaim
        ? 'Noted. Your answer matches. Please bring your original ID to our Doc-Find point in ${town ?? 'Douala'} and we will hand it over.'
        : 'Happy to help. A team member will reply shortly.';

    final ChatMessage reply = ChatMessage(
      id: 'reply_${DateTime.now().millisecondsSinceEpoch}',
      isFromUser: false,
      text: replyText,
      timestamp: DateTime.now(),
    );

    final List<ChatMessage> updatedMessages = <ChatMessage>[
      ..._threads[index].messages,
      reply,
    ];

    _threads[index] = _threads[index].copyWith(messages: updatedMessages);
    return reply;
  }

  Future<ChatThread> createClaimThread({
    required int listingId,
    required String listingTitle,
    required String town,
    required String claimAnswer,
    bool hasIdPhoto = false,
  }) async {
    final int existingIndex = _threads.indexWhere(
      (ChatThread t) => t.listingId == listingId,
    );
    if (existingIndex != -1) {
      return _threads[existingIndex];
    }

    final int newId = _threads.isEmpty
        ? 1
        : _threads
                  .map((ChatThread t) => t.id)
                  .reduce((int a, int b) => a > b ? a : b) +
              1;

    final ChatThread newThread = ChatThread(
      id: newId,
      listingId: listingId,
      title: listingTitle,
      subtitle: 'Claim under review',
      unreadCount: 1,
      messages: <ChatMessage>[
        ChatMessage(
          id: 'claim_msg_${newId}_1',
          isFromUser: true,
          text:
              'I think this is my document.\nVerification answer: $claimAnswer${hasIdPhoto ? '\n[ID Photo Attached]' : ''}',
          timestamp: DateTime.now(),
        ),
        ChatMessage(
          id: 'claim_msg_${newId}_2',
          isFromUser: false,
          text:
              'Thanks. We received your answer and will check it against the document. This usually takes a few minutes.',
          timestamp: DateTime.now().add(const Duration(seconds: 1)),
        ),
      ],
    );

    _threads.insert(0, newThread);
    return newThread;
  }
}
