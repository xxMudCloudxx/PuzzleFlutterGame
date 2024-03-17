import 'dart:math';
import 'package:image/image.dart' as imglib;

class ListHandle {
  static List<List<int>> shuffleGrid(List<List<int>> grid) {
    Random random = Random();
    List<List<int>> shuffledGrid = List<List<int>>.from(
        grid); // Make a shallow copy

    for (int i = 0; i < shuffledGrid.length; i++) {
      for (int j = 0; j < shuffledGrid[i].length; j++) {
        int randomRow = random.nextInt(shuffledGrid.length);
        int randomCol = random.nextInt(shuffledGrid[i].length);

        // Swap elements
        int temp = shuffledGrid[i][j];
        shuffledGrid[i][j] = shuffledGrid[randomRow][randomCol];
        shuffledGrid[randomRow][randomCol] = temp;
      }
    }
    return shuffledGrid;
  }

  // static List<List<int>> convertTo2DList(List<imglib.Image> list, int rows, int cols) {
  //   if (list.length != rows * cols) {
  //     throw ArgumentError('Number of elements in list should be equal to rows * cols');
  //   }
  //
  //   List<List<int>> result = [];
  //   int index = 0;
  //
  //   for (int i = 0; i < rows; i++) {
  //     List<int> row = [];
  //     for (int j = 0; j < cols; j++) {
  //       row.add(list[index]);
  //       index++;
  //     }
  //     result.add(row);
  //   }
  //
  //   return result;
  // }

}