import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fancykeypad/fancykeypad.dart';

void main() {
  late Widget keypadWidget;

  setUpAll(() {
    final notifier = ValueNotifier<String>("");
    keypadWidget = MaterialApp(
      home: Material(
        child: Column(children: [
          Expanded(
            flex: 2,
            child: ValueListenableBuilder(
              valueListenable: notifier,
              builder: (_, String val, __) {
                return Text(val);
              },
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FancyKeypad(
                onKeyTap: (va) {
                  notifier.value = va;
                },
                maxLength: 4,
              ),
            ),
          )
        ]),
      ),
    );
  });

  group("Keypad test", () {
    testWidgets("Verify has required number of keypad", (widgetTester) async {
      await widgetTester.pumpWidget(keypadWidget);
      await widgetTester.pumpAndSettle();
      final keyPads = find.byType(FancyKeypadButton);
      expect(keyPads, findsNWidgets(6));
    });

    testWidgets("Verify correct text are returned when key is pressed",
        (widgetTester) async {
      String expectedtext = "";
      await widgetTester.pumpWidget(keypadWidget);
      await widgetTester.pumpAndSettle();
      final oneKey = find.text("1");
      expect(oneKey, findsOneWidget);
      final twoKey = find.text("2");
      expect(twoKey, findsOneWidget);
      final threeKey = find.text("3");
      expect(threeKey, findsOneWidget);
      await widgetTester.tap(oneKey);
      await widgetTester.pumpAndSettle(Duration(seconds: 2));
      expectedtext += "1";
      await widgetTester.tap(twoKey);
      await widgetTester.pumpAndSettle(Duration(seconds: 2));
      expectedtext += "2";
      await widgetTester.tap(threeKey);
      await widgetTester.pumpAndSettle(Duration(seconds: 2));
      expectedtext += "3";
      expect(find.text(expectedtext), findsOneWidget);
    });
  });
}
