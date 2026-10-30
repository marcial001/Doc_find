import '../../../../core/utils/failure.dart';
import '../../../../core/utils/result.dart';
import '../../../../shared/domain/entities/chat_thread.dart';
import '../../domain/repositories/messages_repository.dart';
import '../datasources/mock_messages_datasource.dart';

class MessagesRepositoryImpl implements MessagesRepository {
  MessagesRepositoryImpl(this._dataSource);

  final MockMessagesDataSource _dataSource;

  @override
  Future<Result<List<ChatThread>>> getThreads() async {
    try {
      final List<ChatThread> threads = await _dataSource.getThreads();
      return Result.success(threads);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<ChatThread>> getThreadById(int id) async {
    try {
      final ChatThread thread = await _dataSource.getThreadById(id);
      return Result.success(thread);
    } catch (e) {
      return Result.failure(ServerFailure('Thread not found: $e'));
    }
  }

  @override
  Future<Result<ChatThread>> markAsRead(int threadId) async {
    try {
      final ChatThread thread = await _dataSource.markAsRead(threadId);
      return Result.success(thread);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<ChatThread>> sendMessage({
    required int threadId,
    required String text,
  }) async {
    try {
      final ChatThread thread = await _dataSource.sendMessage(
        threadId: threadId,
        text: text,
      );
      return Result.success(thread);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Result<ChatThread>> createClaimThread({
    required int listingId,
    required String listingTitle,
    required String town,
    required String claimAnswer,
    bool hasIdPhoto = false,
  }) async {
    try {
      final ChatThread thread = await _dataSource.createClaimThread(
        listingId: listingId,
        listingTitle: listingTitle,
        town: town,
        claimAnswer: claimAnswer,
        hasIdPhoto: hasIdPhoto,
      );
      return Result.success(thread);
    } catch (e) {
      return Result.failure(ServerFailure(e.toString()));
    }
  }

  Future<ChatMessage> generateAutoReply(int threadId, {String? town}) {
    return _dataSource.generateAutoReply(threadId, town: town);
  }
}
