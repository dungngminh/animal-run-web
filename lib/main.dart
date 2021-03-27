import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ninja/game_screens/playscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.util.fullScreen();
  Flame.util.setOrientation(DeviceOrientation.landscapeLeft);
  runApp(MyGame());
}

class MyGame extends StatefulWidget {
  @override
  _MyGameState createState() => _MyGameState();
}

class _MyGameState extends State<MyGame> {
  AnimalRun game;
  @override
  void initState() {
    super.initState();
    game = AnimalRun();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Animal Run",
      home: game.widget,
    );
  }
}
