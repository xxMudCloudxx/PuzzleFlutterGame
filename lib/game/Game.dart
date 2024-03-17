
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'GameHeader.dart';
import 'GamePanel.dart';

class GamePuzzle extends StatefulWidget{

  @override
  State<GamePuzzle> createState() => GameState();
}

class GameState extends State<GamePuzzle> {
  static const Color tan = Color.fromARGB(255, 238, 235, 218);
  GamePanel panel = GamePanel();
  GameHeader header= GameHeader();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: Container(
          padding: EdgeInsets.only(top: 30),
          color: tan,
          child: Column(
            children: [
              Flexible(child: header),
              Flexible(flex: 2,child: panel)
            ],
          ),
        )
    );
  }
}