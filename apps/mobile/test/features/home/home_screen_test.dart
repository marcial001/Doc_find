import 'package:doc_find/core/l10n/l10n.dart';
import 'package:doc_find/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeScreen', () {
    testWidgets('renders Hero carousel, indicators, quick actions, and floating admin chat button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const Scaffold(
              body: HomeScreen(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // 1. Verify Hero Carousel first slide
      expect(find.text('NATIONAL SERVICE'), findsOneWidget);
      expect(find.text('Lost or Found a Document?'), findsOneWidget);
      expect(find.text('Search Documents'), findsOneWidget);

      // 2. Verify Quick Actions
      expect(find.text('Search Lost'), findsOneWidget);
      expect(find.text('Report Found'), findsOneWidget);
      expect(find.text('New Alert'), findsOneWidget);

      // 3. Verify Metrics
      expect(find.text('1,240+'), findsOneWidget);
      expect(find.text('Recovered'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
      expect(find.text('Regions'), findsOneWidget);

      // 4. Verify Floating Admin Chat Button
      expect(find.text('Chat with Admin'), findsOneWidget);
      expect(find.byIcon(Icons.support_agent_rounded), findsOneWidget);

      // 5. Verify Carousel swipe to slide 2
      await tester.drag(find.text('Lost or Found a Document?'), const Offset(-400, 0));
      await tester.pumpAndSettle();

      expect(find.text('CAMEROON LAW NO. 2024/017'), findsOneWidget);
      expect(find.text('Privacy by Law No. 2024/017'), findsOneWidget);
      expect(find.text('Privacy Protected'), findsOneWidget);
    });

    testWidgets('tap on privacy action opens Law No. 2024/017 bottom sheet', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const Scaffold(
              body: HomeScreen(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Swipe to slide 2 (Privacy)
      await tester.drag(find.text('Lost or Found a Document?'), const Offset(-400, 0));
      await tester.pumpAndSettle();

      // Tap Privacy Protected button
      await tester.tap(find.text('Privacy Protected'));
      await tester.pumpAndSettle();

      // Verify bottom sheet content
      expect(find.text('Cameroon Law No. 2024/017'), findsOneWidget);
      expect(find.text('Certified Personal Data Protection'), findsOneWidget);
      expect(find.text('Understood'), findsOneWidget);

      // Close bottom sheet
      await tester.tap(find.text('Understood'));
      await tester.pumpAndSettle();

      expect(find.text('Certified Personal Data Protection'), findsNothing);
    });
  });
}
