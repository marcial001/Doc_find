import 'package:doc_find/core/l10n/l10n.dart';
import 'package:doc_find/features/messages/presentation/screens/messages_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MessagesScreen renders title, subtitle and thread list', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MessagesScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));

    expect(find.text('Messages'), findsOneWidget);
    expect(
      find.text('You talk to the Doc-Find team. Never directly to the finder.'),
      findsOneWidget,
    );
    expect(find.text('Doc-Find team'), findsOneWidget);
    expect(find.text('DF'), findsOneWidget);
  });
}
