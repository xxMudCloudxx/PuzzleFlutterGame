import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puzzle/game/GameMap.dart';

import 'assets.dart';


class GameHeader extends StatefulWidget {
  @override
  State<GameHeader> createState() => _GameHeader();
}

class _GameHeader extends State<GameHeader> {
  _GameHeader() {
    initState();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 40, 0, 0),
            child: Column(
              children: [
                const Text("拼图",
                  style: TextStyle(
                      fontSize: 75,
                      color: Color.fromARGB(255, 119, 110, 101),
                      fontWeight: FontWeight.bold
                  ),),
                SizedBox(height: 12,),
                newGame()
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 40, 25, 0),
            child: Image.asset(
              Assets.img1,
              fit: BoxFit.fill,
              width: 170,
              height: 170,
            )
          ),
        ]
    );
  }

  Container newGame() {
    return Container(
      height: 60,
      width: 160,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Color.fromARGB(255, 147, 131, 117)
      ),
      child: InkWell(
        onTap: () {
          Provider.of<GameMap>(context, listen: false).init();
        },
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('NEW GAME', style: TextStyle(
                color: Color.fromARGB(255, 246, 240, 229), fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 1,)
          ],
        ),
      ),
    );
  }
}