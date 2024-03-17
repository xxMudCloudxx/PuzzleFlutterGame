import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'game/Game.dart';
import 'game/GameMap.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (_) => GameMap(),
      child: MaterialApp(
        home: MyGame(),
      )
  ));
}

class MyGame extends StatelessWidget {
  Widget build(BuildContext context) {
    return GamePuzzle();
  }
}