import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:win_test/presentation/effects/effect1.dart';
import 'package:win_test/presentation/effects/effect2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FluentApp(

      theme: ThemeData(brightness: Brightness.dark),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{

  int index = 2;

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      pane: NavigationPane(
        selected: index,
        onChanged: (val){
          setState(() {
            index = val;
          });
        },
        displayMode: PaneDisplayMode.compact,
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.color),
            title: const Text("Effect_01"),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.focus),
            title: const Text("Effect_02"),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.step),
            title: const Text("Effect_03"),
          )
        ]
      ),
      content: NavigationBody(
        index: index,
        children: const [
          Effect1(),
          Effect2(),
          SizedBox()
        ],
      ),
    );
  }
}




