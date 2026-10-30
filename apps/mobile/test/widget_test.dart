import 'package:doc_find/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DocFindApp boots and renders initial splash route', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: DocFindApp()));
    await tester.pump();

    expect(find.text('Doc-Find'), findsOneWidget);

    // Pump past splash timer
    await tester.pump(const Duration(seconds: 4));
  });
}
