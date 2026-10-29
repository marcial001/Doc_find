import 'package:doc_find/core/widgets/empty_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EmptyStateWidget', () {
    testWidgets('renders title, message, and executes action', (
      WidgetTester tester,
    ) async {
      bool actionTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              title: 'No match yet',
              message: 'Try another town or date.',
              actionLabel: 'Alert me for this search',
              onAction: () => actionTriggered = true,
            ),
          ),
        ),
      );

      expect(find.text('No match yet'), findsOneWidget);
      expect(find.text('Try another town or date.'), findsOneWidget);
      expect(find.text('Alert me for this search'), findsOneWidget);

      await tester.tap(find.text('Alert me for this search'));
      expect(actionTriggered, isTrue);
    });
  });
}
