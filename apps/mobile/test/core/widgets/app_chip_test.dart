import 'package:doc_find/core/widgets/app_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppChip', () {
    testWidgets('renders label and handles tap', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppChip(
              label: 'ID card',
              isSelected: false,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('ID card'), findsOneWidget);
      await tester.tap(find.byType(AppChip));
      expect(tapped, isTrue);
    });

    testWidgets('shows selected state with scale animation', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppChip(label: 'Passport', isSelected: true, onTap: () {}),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final AnimatedScale scaleWidget = tester.widget<AnimatedScale>(
        find.byType(AnimatedScale),
      );
      expect(scaleWidget.scale, 1.04);
    });
  });
}
