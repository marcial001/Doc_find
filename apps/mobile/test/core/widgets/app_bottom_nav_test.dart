import 'package:doc_find/core/widgets/app_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppBottomNav', () {
    testWidgets('renders all 4 tabs and calls onTabSelected', (
      WidgetTester tester,
    ) async {
      NavTab selected = NavTab.search;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            bottomNavigationBar: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return AppBottomNav(
                  currentTab: selected,
                  unreadMessagesCount: 2,
                  onTabSelected: (NavTab tab) {
                    setState(() => selected = tab);
                  },
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Report'), findsOneWidget);
      expect(find.text('Alerts'), findsOneWidget);

      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();

      expect(selected, NavTab.home);

      await tester.tap(find.text('Report'));
      await tester.pumpAndSettle();

      expect(selected, NavTab.report);

      await tester.tap(find.text('Alerts'));
      await tester.pumpAndSettle();

      expect(selected, NavTab.alerts);
    });
  });
}
