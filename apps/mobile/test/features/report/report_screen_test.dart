import 'package:doc_find/core/l10n/l10n.dart';
import 'package:doc_find/features/report/presentation/controllers/report_controller.dart';
import 'package:doc_find/features/report/presentation/screens/report_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ReportScreen renders headline, info note and Start report CTA', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ReportScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));

    expect(find.text('I found a\ndocument'), findsOneWidget);
    expect(
      find.text(
        'The full document is never shown to the public. We blur the photo and hide the ID number.',
      ),
      findsOneWidget,
    );
    expect(find.text('Start report'), findsOneWidget);
    expect(find.text('Your recent reports'), findsOneWidget);
    expect(
      find.text(
        'No reports yet. Thank you for being honest enough to be here.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('ReportScreen renders recent reports list when reports exist', (
    WidgetTester tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(reportControllerProvider.notifier);

    await tester.runAsync(() async {
      controller.capturePhoto();
      controller.setSpot('Marché A');
      controller.setTown('Bafoussam');
      controller.toggleConsentStorage();
      controller.toggleConsentContact();
      await controller.submitReport();
    });

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ReportScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));

    expect(find.text('Bafoussam'), findsOneWidget);
    expect(find.text('Marché A'), findsOneWidget);
    expect(find.text('In review'), findsOneWidget);
  });
}
