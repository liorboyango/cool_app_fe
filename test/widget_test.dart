import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:cool_app_fe/main.dart';
import 'package:cool_app_fe/theme_notifier.dart';

void main() {
  testWidgets('Home page renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ));

    expect(find.text('Collest Main Screen Ever!'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });

  testWidgets('Search field clear button appears and works', (WidgetTester tester) async {
    await tester.pumpWidget(ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ));

    final textFieldFinder = find.byType(TextField);
    expect(textFieldFinder, findsOneWidget);

    expect(find.byIcon(Icons.clear), findsNothing);

    await tester.enterText(textFieldFinder, 'test');
    await tester.pump();

    expect(find.byIcon(Icons.clear), findsOneWidget);

    await tester.tap(find.byIcon(Icons.clear));
    await tester.pump();

    expect(find.byIcon(Icons.clear), findsNothing);

    final textField = tester.widget<TextField>(textFieldFinder);
    expect(textField.controller!.text, '');
  });

  testWidgets('Settings screen can be opened and has toggle', (WidgetTester tester) async {
    await tester.pumpWidget(ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ));

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Dark Theme'), findsOneWidget);
  });
}
