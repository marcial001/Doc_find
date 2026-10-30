import 'package:doc_find/core/l10n/l10n.dart';
import 'package:doc_find/features/messages/presentation/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ChatScreen displays conversation and sends message', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ChatScreen(threadId: 0),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));

    expect(find.text('Doc-Find team'), findsOneWidget);
    expect(find.text('Doc-Find team · replies in minutes'), findsOneWidget);
    expect(
      find.text(
        'Welcome to Doc-Find. Ask us anything about finding or returning a document.',
      ),
      findsOneWidget,
    );

    // Send a message
    await tester.enterText(find.byType(TextField), 'Test message from user');
    await tester.tap(find.byIcon(Icons.send_rounded));
    await tester.pump();

    expect(find.text('Test message from user'), findsOneWidget);

    // Drain typing timer (1400ms)
    await tester.pump(const Duration(milliseconds: 1600));
    await tester.pump(const Duration(milliseconds: 100));
  });
}
