import 'package:doc_find/core/l10n/l10n.dart';
import 'package:doc_find/core/widgets/app_switch.dart';
import 'package:doc_find/features/alerts/presentation/screens/alerts_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AlertsScreen renders title, subtitle, alert cards and toggles', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: AlertsScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));

    expect(find.text('Saved search alerts'), findsOneWidget);
    expect(
      find.text('We notify you when a matching document is posted.'),
      findsOneWidget,
    );
    expect(find.text('ID card · Douala'), findsOneWidget);
    expect(find.text('Push + SMS when posted'), findsOneWidget);
    expect(find.text('Passport · Any town'), findsOneWidget);
    expect(find.text('Paused'), findsOneWidget);

    // Toggle the first switch
    final Finder firstSwitch = find.byType(AppSwitch).first;
    await tester.tap(firstSwitch);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));

    expect(find.text('Paused'), findsNWidgets(2));
  });
}
