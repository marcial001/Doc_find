import 'package:doc_find/core/constants/document_types.dart';
import 'package:doc_find/core/l10n/l10n.dart';
import 'package:doc_find/core/widgets/app_button.dart';
import 'package:doc_find/features/claim/presentation/sheets/claim_sheet.dart';
import 'package:doc_find/shared/domain/entities/listing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'ClaimSheet shows verification question and validates answer length >= 2',
    (WidgetTester tester) async {
      const Listing testListing = Listing(
        id: 1,
        type: DocumentType.id,
        name: 'K•••• N••••••',
        town: 'Douala',
        spot: 'Akwa',
        daysAgo: 0,
        note: 'Note',
        question: 'Which town issued your card?',
      );

      bool claimed = false;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () {
                    ClaimSheet.show(
                      context: context,
                      listing: testListing,
                      onClaimSuccess: () => claimed = true,
                    );
                  },
                  child: const Text('Open Claim'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Claim'));
      await tester.pumpAndSettle();

      expect(find.text("Prove it's yours"), findsOneWidget);
      expect(find.text('Which town issued your card?'), findsOneWidget);

      // Enter answer with length 1 - button remains disabled
      await tester.enterText(find.byType(TextField), 'D');
      await tester.pump();

      // Enter valid answer (length >= 2)
      await tester.enterText(find.byType(TextField), 'Douala');
      await tester.pump();

      await tester.tap(find.byType(AppButton));
      await tester.pumpAndSettle();

      expect(claimed, isTrue);

      // Drain toast timer
      await tester.pump(const Duration(seconds: 3));
    },
  );
}
