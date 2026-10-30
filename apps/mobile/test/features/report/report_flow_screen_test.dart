import 'package:doc_find/core/l10n/l10n.dart';
import 'package:doc_find/features/report/presentation/screens/report_flow_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ReportFlowScreen walks through all 3 steps to success', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ReportFlowScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Step 0: Photograph it
    expect(find.text('Photograph it'), findsOneWidget);
    expect(
      find.text('Place the document flat and fit it inside the frame'),
      findsOneWidget,
    );

    // Tap shutter button (circle gesture)
    final Finder shutter = find.byKey(const ValueKey('shutter_button'));
    await tester.tap(shutter);
    // Flash duration is 260ms
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();

    expect(find.text('Retake photo'), findsOneWidget);

    // Tap Continue to Step 1
    await tester.tap(find.text('Continue'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Step 1: Where and what
    expect(find.text('Where and what'), findsOneWidget);
    expect(find.text('Document type'), findsOneWidget);

    // Enter spot >= 3 chars
    await tester.enterText(
      find.widgetWithText(TextField, 'e.g. Marché Mokolo, near the bank'),
      'Marché Central',
    );
    await tester.pump();

    // Tap Continue to Step 2
    await tester.tap(find.text('Continue'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Step 2: Consent
    expect(find.text('Your consent'), findsOneWidget);
    expect(
      find.text('Nothing is selected for you. Tick each box to agree.'),
      findsOneWidget,
    );

    // Check both consent boxes
    await tester.tap(find.text('Photo and location'));
    await tester.pump();
    await tester.tap(find.text('Phone number for handoff'));
    await tester.pump();

    // Submit for review
    await tester.tap(find.text('Submit for review'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Step 3: Success
    expect(find.text('Report sent'), findsOneWidget);
    expect(find.text('Thank you'), findsOneWidget);
    expect(find.text('Report received'), findsOneWidget);
    expect(find.text('Team review'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);
  });
}
