import 'package:fancykeypad/fancykeypad.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String value = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Text(
                value,
                style: const TextStyle(
                    fontSize: 30.0, fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: FancyKeypad(
                  textColor: Colors.red,
                  splashColor: Colors.green,
                  enableDot: true,
                  onKeyTap: (val) {
                    setState(() {
                      value = val;
                    });
                  },
                  maxAllowableCharacters: 5,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
