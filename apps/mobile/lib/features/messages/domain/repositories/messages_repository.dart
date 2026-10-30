import '../../../../core/utils/result.dart';
import '../../../../shared/domain/entities/chat_thread.dart';

abstract class MessagesRepository {
  Future<Result<List<ChatThread>>> getThreads();
  Future<Result<ChatThread>> getThreadById(int id);
  Future<Result<ChatThread>> sendMessage({
    required int threadId,
    required String text,
  });
  Future<Result<ChatThread>> markAsRead(int threadId);
  Future<Result<ChatThread>> createClaimThread({
    required int listingId,
    required String listingTitle,
    required String town,
    required String claimAnswer,
    bool hasIdPhoto = false,
  });
}
