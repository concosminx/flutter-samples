
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hackernewsapp/main.dart';

//run with: flutter test
//run visual with: flutter run test/widget_test.dart

void main() {
  testWidgets('Simple Flutter test', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.byIcon(Icons.launch), findsNothing);

    await tester.tap(find.byType(ExpansionTile).first);
    await tester.pump(Duration(milliseconds: 100));

    expect(find.byIcon(Icons.launch), findsOneWidget);

  }, skip:true);
}
