import 'package:doc_find/core/l10n/l10n.dart';
import 'package:doc_find/core/widgets/redacted_doc.dart';
import 'package:doc_find/features/splash/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SplashScreen renders document card, title, and tagline', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SplashScreen(),
        ),
      ),
    );

    expect(find.byType(RedactedDoc), findsOneWidget);
    expect(find.text('Doc-Find'), findsOneWidget);
    expect(find.text('Tap anywhere to skip'), findsOneWidget);

    // Pump past splash timer so no pending timers remain
    await tester.pump(const Duration(seconds: 4));
  });
}
