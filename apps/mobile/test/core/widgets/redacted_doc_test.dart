import 'package:doc_find/core/constants/document_types.dart';
import 'package:doc_find/core/widgets/redacted_doc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RedactedDoc', () {
    testWidgets('renders all document types with badge and semantics', (
      WidgetTester tester,
    ) async {
      for (final DocumentType type in DocumentType.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: RedactedDoc(type: type)),
          ),
        );

        expect(find.text(type.badge), findsOneWidget);
        expect(
          find.byWidgetPredicate(
            (Widget w) =>
                w is Semantics &&
                w.properties.label ==
                    '${type.label} with redacted personal details',
          ),
          findsOneWidget,
        );
      }
    });

    testWidgets('renders large variant with custom dimensions', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RedactedDoc(type: DocumentType.id, isLarge: true),
          ),
        ),
      );

      final Size size = tester.getSize(find.byType(RedactedDoc));
      expect(size.width, 320);
      expect(size.height, 202);
      expect(find.text('ID'), findsOneWidget);
    });
  });
}
