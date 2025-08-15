import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:claims_app/main.dart' as app;
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app shows claims list', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(find.text("Claims"), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 3));

    final firstItem = find.byType(ListTile).first;
    expect(firstItem, findsOneWidget);

    await tester.tap(firstItem);
    await tester.pumpAndSettle();

    expect(find.text("Claim Detail"), findsOneWidget);

    expect(find.byType(Text), findsWidgets);
  });
}
