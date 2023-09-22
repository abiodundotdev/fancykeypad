import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fancykeypad/fancykeypad.dart';

void main() {
  late Widget keypadWidget;

  setUpAll(() {
    keypadWidget = MaterialApp(
      home: Material(child: FancyKeypad(onKeyTap: (va) {}, maxLength: 4)),
    );
  });

  group("Keypad test", () {
    testWidgets("Vefiry has required ", (widgetTester) async {
      await widgetTester.pumpWidget(keypadWidget);
      //final finder  =
    });
  });
}
