import 'package:doc_find/core/l10n/l10n.dart';
import 'package:doc_find/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'OnboardingScreen renders first slide and advances with Next button',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: OnboardingScreen(),
        ),
      );
      await tester.pump();

      expect(find.text('Lost an ID or passport?'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
      expect(find.text('Skip'), findsOneWidget);

      // Tap Next to advance to slide 2
      await tester.tap(find.text('Next'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Found one? Report it fast.'), findsOneWidget);

      // Tap Next to advance to slide 3
      await tester.tap(find.text('Next'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('A safe handoff, every time.'), findsOneWidget);
      expect(find.text('Get started'), findsOneWidget);
    },
  );
}
