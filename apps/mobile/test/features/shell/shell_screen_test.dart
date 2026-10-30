import 'package:doc_find/core/l10n/l10n.dart';
import 'package:doc_find/core/widgets/app_bottom_nav.dart';
import 'package:doc_find/features/shell/presentation/screens/shell_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ShellScreen renders top bar, title, bell, avatar, and bottom nav', (
    WidgetTester tester,
  ) async {
    NavTab? selectedTab;

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ShellScreen(
            currentTab: NavTab.search,
            unreadMessagesCount: 2,
            child: const Center(child: Text('Shell Content Body')),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Doc-Find'), findsOneWidget);
    expect(find.text('Shell Content Body'), findsOneWidget);
    expect(find.byIcon(Icons.notifications_none_rounded), findsNWidgets(2));
    expect(find.text('DF'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Report'), findsOneWidget);
    expect(find.text('Messages'), findsOneWidget);
    expect(find.text('Alerts'), findsOneWidget);
  });
}
