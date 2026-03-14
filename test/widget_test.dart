import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quickbasket/main.dart';

void main() {
  testWidgets('QuickBasket app starts and shows login',
      (WidgetTester tester) async {
    await tester.pumpWidget(const QuickBasketApp());
    expect(find.text('QuickBasket'), findsOneWidget);
  });
}
