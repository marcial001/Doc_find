import 'package:doc_find/core/widgets/app_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppSwitch', () {
    testWidgets('toggles value on tap and calls onChanged', (
      WidgetTester tester,
    ) async {
      bool currentValue = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return AppSwitch(
                  value: currentValue,
                  semanticLabel: 'SMS notifications',
                  onChanged: (bool newVal) {
                    setState(() => currentValue = newVal);
                  },
                );
              },
            ),
          ),
        ),
      );

      expect(find.bySemanticsLabel('SMS notifications'), findsOneWidget);

      await tester.tap(find.byType(AppSwitch));
      await tester.pumpAndSettle();

      expect(currentValue, isTrue);

      await tester.tap(find.byType(AppSwitch));
      await tester.pumpAndSettle();

      expect(currentValue, isFalse);
    });
  });
}
