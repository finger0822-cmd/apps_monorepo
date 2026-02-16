// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:one_sentence_app/main.dart';

void main() {
  testWidgets('renders minimal one sentence UI', (WidgetTester tester) async {
    await tester.pumpWidget(const OneSentenceApp());

    expect(find.text('まだ一文がありません'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.widgetWithText(FilledButton, '更新する'), findsOneWidget);
  });
}
