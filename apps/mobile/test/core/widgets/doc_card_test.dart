import 'package:doc_find/core/constants/document_types.dart';
import 'package:doc_find/core/widgets/doc_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DocCard', () {
    testWidgets('renders document details and triggers onTap', (
      WidgetTester tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DocCard(
              id: 1,
              type: DocumentType.id,
              name: 'K•••• N••••••',
              town: 'Douala',
              spot: 'Akwa, near Rond-point Deido',
              daysAgo: 0,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('K•••• N••••••'), findsOneWidget);
      expect(find.text('Douala · Akwa, near Rond-point Deido'), findsOneWidget);
      expect(find.text('ID card'), findsOneWidget);
      expect(find.text('Today'), findsOneWidget);

      await tester.tap(find.byType(DocCard));
      expect(tapped, isTrue);
    });

    testWidgets('formats days ago correctly for yesterday and older', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: <Widget>[
                DocCard(
                  id: 2,
                  type: DocumentType.pass,
                  name: 'M•••• T••••',
                  town: 'Yaoundé',
                  spot: 'Mvan bus park',
                  daysAgo: 1,
                ),
                DocCard(
                  id: 3,
                  type: DocumentType.birth,
                  name: 'E•••• A••••',
                  town: 'Bafoussam',
                  spot: 'Marché A',
                  daysAgo: 5,
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Yesterday'), findsOneWidget);
      expect(find.text('5 days ago'), findsOneWidget);
    });
  });
}
