import 'package:doc_find/core/l10n/l10n.dart';
import 'package:doc_find/core/widgets/redacted_doc.dart';
import 'package:doc_find/features/listing_detail/presentation/screens/listing_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'ListingDetailScreen displays full document information and CTA',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: ListingDetailScreen(listingId: 1),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.byType(RedactedDoc), findsOneWidget);
      expect(find.text('K•••• N••••••'), findsOneWidget);
      expect(find.text('Douala'), findsOneWidget);
      expect(find.text('Akwa, near Rond-point Deido'), findsOneWidget);
      expect(find.text('This is my document'), findsOneWidget);
    },
  );
}
