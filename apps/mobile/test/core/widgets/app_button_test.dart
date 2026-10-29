import 'package:doc_find/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppButton', () {
    testWidgets('renders label and triggers onPressed when enabled', (
      WidgetTester tester,
    ) async {
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              label: 'Submit for review',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Submit for review'), findsOneWidget);
      await tester.tap(find.byType(AppButton));
      expect(pressed, isTrue);
    });

    testWidgets('shows loading spinner when isLoading is true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(label: 'Submit', isLoading: true, onPressed: () {}),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Submit'), findsNothing);
    });

    testWidgets('disabled button does not trigger callback', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppButton(label: 'Disabled', onPressed: null)),
        ),
      );

      await tester.tap(find.byType(AppButton));
      // No exception, button safely disabled
    });
  });
}
