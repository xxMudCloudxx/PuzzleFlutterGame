
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imglib;
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:puzzle/game/GameMap.dart';


class GamePanel extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GameHeaderState();
}

class GameHeaderState extends State<GamePanel>{
  String _selectedDifficulty = '简单';
  GlobalKey _redKey = GlobalKey();
  bool isgameOver = false;
  bool _firstTouch = true;

  Map<ObjectKey, Offset> puzzleCenterPositions = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<GameMap>(context, listen: false).init();
  }

  void resetGame() {
    setState(() {
      Provider.of<GameMap>(context, listen: false).init();
      isgameOver = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isgameOver) {
      return Column(
        children: [
          Stack(
            children: [
              _gamePanel(context),
              _gameReset(context)
            ],
          ),DifficultyButton(),
        ],
      );
    } else {
      return Column(
        children: [
          _gamePanel(context),
          DifficultyButton(),
        ],
      );
    }
  }

  ElevatedButton DifficultyButton() {
    return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 147, 131, 117)// 设置按钮背景颜色为蓝色
          ),
          onPressed: () {
            _showDifficultyDialog();
          },
          child: Text('设置难度 ($_selectedDifficulty)'),
        );
  }

  Widget _gamePanel(BuildContext context) {
    int SIZE = Provider.of<GameMap>(context, listen: false).SIZE;
    Offset lastPositon = Offset.zero;
    return GestureDetector(
      onPanDown: (DragDownDetails details) {
        lastPositon = details.globalPosition;
        _firstTouch = true;
      },
      onPanUpdate: (details) {
        final curPosition = details.globalPosition;
        double min = (puzzleCenterPositions[ObjectKey(0)]! - puzzleCenterPositions[ObjectKey(1)]!).distance/2;
        if ((curPosition - lastPositon).distance > min)
        moveJudge(lastPositon, curPosition);
      },

      child: Frame(context,
          Container(
            child: MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: Provider.of<GameMap>(context, listen: false).SIZE,
                        childAspectRatio: 1,
                        mainAxisSpacing: 3,
                        crossAxisSpacing: 3
                    ),
                    itemCount: SIZE * SIZE,
                    itemBuilder: (context, int index) {
                      return PuzzlePart(Provider.of<GameMap>(context, listen: true).get(index), index);
                    })
            ),
          )
      ),
    );
  }

  Widget _gameReset(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1.0,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Game Over",style: TextStyle(
                fontSize: 50,
                color: Colors.white70
              ),),
              InkWell(
                  onTap: () {
                    resetGame();
                  },
                  child: const Text("Reset",style: TextStyle(
                      fontSize: 30,
                      color: Colors.white70
                  ),),)
            ],
          ),
        ));
  }

  AspectRatio Frame(BuildContext context, Widget child) {
    double minSize = min(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        key: _redKey,
        color: Color.fromRGBO(182,173,156,1),
        width: minSize,
        height: minSize,
        margin: EdgeInsets.all(10),
        child: child
      ),
    );
  }


  Widget PuzzlePart(imglib.Image img, int index) {
    return Builder(
      builder: (BuildContext context) {
        ObjectKey key = ObjectKey(index); // 创建一个ObjectKey作为该组件的key
        Widget puzzleWidget = Container(
          key: key,
          child: Image.memory(imglib.encodeJpg(img)),
        );
        // 获取拼图组件的中心位置
        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          Offset center = renderBox.localToGlobal(
              renderBox.size.center(Offset.zero));
          // 将拼图组件的中心位置存储到Map中
          puzzleCenterPositions[key] = center;
        });
        return puzzleWidget;
      },
    );
  }

  void moveJudge(Offset last, Offset cur) {
    int SIZE = Provider.of<GameMap>(context, listen: false).SIZE;
    double min = (puzzleCenterPositions[ObjectKey(0)]! - puzzleCenterPositions[ObjectKey(1)]!).distance/1.5;
    if (_firstTouch){
      for (int i = 0; i < SIZE * SIZE; i++) {
        //print((puzzleCenterPositions[ObjectKey(i)]! - cur).distance);
        if (puzzleCenterPositions[ObjectKey(i)] != null &&(puzzleCenterPositions[ObjectKey(i)]! - last).distance < min) {
          for(int j = 0; j <SIZE*SIZE;j++) {
            //print((puzzleCenterPositions[ObjectKey(j)]! - cur).distance);
            if(puzzleCenterPositions[ObjectKey(j)] != null &&(puzzleCenterPositions[ObjectKey(j)]! - cur).distance < min ) {
              Provider.of<GameMap>(context, listen: false).move(i, j);
              isgameOver = Provider.of<GameMap>(context, listen: false).checkEnd(SIZE * SIZE);
              setState(() {
                _firstTouch = false;
              });
            }
          }
        }
      }
    }
  }
  Future<void> _showDifficultyDialog() async {
    String? selectedDifficulty = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('设置难度'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Provider.of<GameMap>(context, listen: false).SIZE = 3;
                Provider.of<GameMap>(context, listen: false).init();
                Navigator.pop(context, '简单');
              },
              child: Text('简单'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Provider.of<GameMap>(context, listen: false).SIZE = 4;
                Provider.of<GameMap>(context, listen: false).init();
                Navigator.pop(context, '中等');
              },
              child: Text('中等'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Provider.of<GameMap>(context, listen: false).SIZE = 5;
                Provider.of<GameMap>(context, listen: false).init();
                Navigator.pop(context, '困难');
              },
              child: Text('困难'),
            ),
          ],
        );
      },
    );

    if (selectedDifficulty != null) {
      setState(() {
        _selectedDifficulty = selectedDifficulty;
      });
    }
  }
  }




