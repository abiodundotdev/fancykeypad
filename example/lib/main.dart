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
            const SizedBox(height: 100.0),
            Expanded(
              flex: 3,
              child: Text(
                value,
                style: const TextStyle(
                    fontSize: 80.0, fontWeight: FontWeight.w900),
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: FancyKeypad(
                  // backgroundImage: const DecorationImage(
                  //     image: NetworkImage(
                  //         "https://images.unsplash.com/32/Mc8kW4x9Q3aRR3RkP5Im_IMG_4417.jpg?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fGJhY2tncm91bmQlMjBpbWFnZXxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=800&q=60")),
                  // shape: Border.all(
                  //   color: Color(0XFFF3F3F3),
                  // ),
                  // textColor: Colors.white,
                  // splashColor: Colors.green,
                  enableDot: true,
                  onKeyTap: (val) {
                    setState(() {
                      //setState
                      value = val;
                    });
                  },
                  maxLength: 5,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
