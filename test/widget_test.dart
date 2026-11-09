// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:livestream_app/main.dart';

void main() {
  testWidgets('Home screen shows streaming channels and navigation', (tester) async {
    await tester.pumpWidget(const LiveStreamApp());

    expect(find.text('StreamHub'), findsOneWidget);
    expect(find.text('Chaînes'), findsOneWidget);
    expect(find.text('Sport Live'), findsOneWidget);
    expect(find.text('News 24'), findsOneWidget);

    await tester.tap(find.byType(NavigationBar));
    await tester.pumpAndSettle();

    expect(find.text('Guide des programmes'), findsNothing);
  });

  testWidgets('Open channel detail screen', (tester) async {
    await tester.pumpWidget(const LiveStreamApp());

    await tester.tap(find.text('Sport Live'));
    await tester.pumpAndSettle();

    expect(find.text('Programme'), findsOneWidget);
    expect(find.text('Match du jour'), findsOneWidget);
  });
}
