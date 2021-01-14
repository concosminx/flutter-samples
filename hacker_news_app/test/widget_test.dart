import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hackernewsapp/src/widgets/headline.dart';

//run with: flutter test
//run visual with: flutter run test/widget_test.dart

void main() {
  testWidgets('headline animates and changes text correctly',
      (WidgetTester tester) async {
    String text = "Foo";
    int index = 0;
    Key buttonKey = GlobalKey();
    Key headlineKey = GlobalKey();

    Widget widget = StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            children: <Widget>[
              Headline(
                key: headlineKey,
                text: text,
                index: index,
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    text = 'Bar';
                    index = 1;
                  });
                },
                child: Text("Tap"),
                key: buttonKey,
              )
            ],
          ),
        );
      },
    );
    await tester.pumpWidget(
      widget,
    );

    expect(find.text('Foo'), findsOneWidget);

    await tester.pump();

    await tester.tap(find.byKey(buttonKey));

    await tester.pumpAndSettle();

    expect(find.text('Bar'), findsOneWidget);
  });

  testWidgets('headline animates and changes text color correctly',
      (WidgetTester tester) async {
    String text = "Foo";
    int index = 0;
    Key buttonKey = GlobalKey();
    Key headlineKey = GlobalKey();
    Headline headline;

    Widget widget = StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        headline = Headline(
          key: headlineKey,
          text: text,
          index: index,
        );

        return Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            children: <Widget>[
              headline,
              FlatButton(
                onPressed: () {
                  setState(() {
                    text = 'Bar';
                    index = 1;
                  });
                },
                child: Text("Tap"),
                key: buttonKey,
              )
            ],
          ),
        );
      },
    );
    await tester.pumpWidget(
      widget,
    );

    expect(headline.targetColor, headlineTextColors[index]);

    await tester.pump();

    await tester.tap(find.byKey(buttonKey));

    await tester.pumpAndSettle();

    expect(headline.targetColor, headlineTextColors[index]);
  });
}
