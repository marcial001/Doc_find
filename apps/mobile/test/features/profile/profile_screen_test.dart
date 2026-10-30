import 'package:doc_find/core/l10n/l10n.dart';
import 'package:doc_find/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ProfileScreen displays user info, preferences, and toggles', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ProfileScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Profile and settings'), findsOneWidget);
    expect(find.text('Demo User'), findsWidgets);
    expect(find.text('demo@docfind.cm'), findsWidgets);
    expect(find.text('DU'), findsOneWidget);

    // Section headings
    expect(find.text('Avatar colour'), findsOneWidget);
    expect(find.text('Personal details'), findsOneWidget);
    expect(find.text('Preferences'), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Privacy and security'), findsOneWidget);

    // Action rows
    expect(find.text('Change password'), findsOneWidget);
    expect(find.text('Download my data'), findsOneWidget);
    expect(find.text('Delete my account'), findsOneWidget);
    expect(find.text('Log out'), findsOneWidget);

    // Scroll to Preferences and tap Français language chip
    await tester.scrollUntilVisible(
      find.text('Français'),
      100,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Français'));
    await tester.pump();

    // Drain toast timer
    await tester.pump(const Duration(seconds: 3));
  });
}
