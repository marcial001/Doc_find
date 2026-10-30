import 'package:doc_find/core/l10n/l10n.dart';
import 'package:doc_find/core/widgets/doc_card.dart';
import 'package:doc_find/features/search/presentation/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SearchScreen renders title, input, chips, and seed listings', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SearchScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('Find a lost document'), findsOneWidget);
    expect(find.text('All'), findsOneWidget);
    expect(find.text('ID card'), findsWidgets);
    expect(find.text('Alert me for this search'), findsOneWidget);
    expect(find.byType(DocCard), findsWidgets);
  });
}
