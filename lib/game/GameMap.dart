import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as imglib;
import 'package:puzzle/game/assets.dart';

class GameMap with ChangeNotifier{
  int SIZE = 3;
  Future<imglib.Image?> _none = decodeAsset(Assets.none);


  bool firstTouch = false;
  List result = [];
  List pieces = [];
  int one = 1;
  init() {
    final Future<List<imglib.Image>> _pieces = splitImage(Assets.img1, n : SIZE);
    _pieces.then((_pieces) {
    result = List.from(_pieces);
    pieces = List.from(_pieces);
    pieces.shuffle(Random());
    notifyListeners();
    });
}

  setTouch() {
    firstTouch = !firstTouch;
    notifyListeners();
  }

  checkEnd(int size) {
    for(int i = 0; i < size; i++) {
      if (result[i] != pieces[i]) {
        return false;
      }
  }
    return true;
  }

  imglib.Image get(int i) {
    if (one == 1) {
      init();
      one = 0;
    }
    try {
      return pieces[i];
    } catch (e) {
      imglib.Image img = imglib.Image.empty();
      return img;
    }
  }

  move(int pre, int next) {
    imglib.Image pre1 = pieces[pre];
    pieces[pre] = pieces[next];
    pieces[next] = pre1;
  }

}




Future<List<imglib.Image>> splitImage(String path, {int n = 3}) async {
  imglib.Image? image = await decodeAsset(path);

  List<imglib.Image> pieces = [];
  int x = 0, y = 0;
  int width = (image!.width / n).floor();
  int height = (image.height / n).floor();
  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      imglib.Image croppedImage = imglib.copyCrop(image, x: x, y: y, width: width, height: height);
      pieces.add(croppedImage);
      x += width;
    }
    x = 0;
    y += height;
  }

  return pieces;
}

Future<imglib.Image?> decodeAsset(String path) async {
  final ByteData data = await rootBundle.load(path);
  final Uint8List bytes = data.buffer.asUint8List();

  final imglib.Image? image = imglib.decodeImage(bytes);
  return image;
}
