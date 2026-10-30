import 'package:doc_find/features/messages/data/datasources/mock_messages_datasource.dart';
import 'package:doc_find/features/messages/data/repositories/messages_repository_impl.dart';
import 'package:doc_find/features/messages/presentation/controllers/messages_controller.dart';
import 'package:doc_find/shared/domain/entities/chat_thread.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late MockMessagesDataSource dataSource;
  late MessagesRepositoryImpl repository;
  late MessagesController controller;

  setUp(() {
    dataSource = MockMessagesDataSource();
    repository = MessagesRepositoryImpl(dataSource);
    controller = MessagesController(repository);
  });

  tearDown(() {
    controller.dispose();
  });

  test('MessagesController initializes with seed threads', () async {
    await controller.loadThreads();
    expect(controller.state.threads.isNotEmpty, isTrue);
    expect(controller.state.threads.first.title, 'Doc-Find team');
  });

  test('MessagesController sends user message and gets auto reply', () async {
    await controller.loadThreads();
    final int threadId = controller.state.threads.first.id;

    await controller.sendMessage(threadId: threadId, text: 'Hello support');
    expect(controller.state.isTyping, isTrue);

    final ChatThread active = controller.state.activeThread!;
    expect(active.messages.last.text, 'Hello support');
    expect(active.messages.last.isFromUser, isTrue);

    // Wait past 1400ms for simulated reply
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    expect(controller.state.isTyping, isFalse);
    expect(controller.state.activeThread!.messages.last.isFromUser, isFalse);
  });

  test('MessagesController creates claim thread', () async {
    final ChatThread? thread = await controller.createClaimThread(
      listingId: 1,
      listingTitle: 'ID card · Douala',
      town: 'Douala',
      claimAnswer: 'Douala',
      hasIdPhoto: true,
    );

    expect(thread, isNotNull);
    expect(thread!.listingId, 1);
    expect(thread.title, 'ID card · Douala');
    expect(thread.messages.length, 2);
    expect(thread.messages.first.text, contains('[ID Photo Attached]'));
  });
}
