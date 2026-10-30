class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.isFromUser,
    required this.text,
    required this.timestamp,
  });

  final String id;
  final bool isFromUser;
  final String text;
  final DateTime timestamp;
}

class ChatThread {
  const ChatThread({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.messages,
    this.listingId,
    this.unreadCount = 0,
  });

  final int id;
  final String title;
  final String subtitle;
  final List<ChatMessage> messages;
  final int? listingId;
  final int unreadCount;

  ChatMessage? get lastMessage => messages.isNotEmpty ? messages.last : null;

  ChatThread copyWith({
    int? id,
    String? title,
    String? subtitle,
    List<ChatMessage>? messages,
    int? listingId,
    int? unreadCount,
  }) {
    return ChatThread(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      messages: messages ?? this.messages,
      listingId: listingId ?? this.listingId,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
