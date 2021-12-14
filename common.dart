import 'dart:math';

void printArray<T>(List<List<T>> list) {
  for (var y = 0; y < list.length; y++) {
    String line = "Line idx: $y:  ";
    for (var x = 0; x < list[y].length; x++) {
      line += list[y][x].toString();
    }

    print(line);
  }
}

void printPoints(List<Point<int>> points) {
  var maxPoint = points.reduce((max, p) => Point(
        p.x < max.x ? max.x : p.x,
        p.y < max.y ? max.y : p.y,
      ));

  var numbers =
      List<List<num>>.generate(maxPoint.y + 1, (_) => List<int>.filled(maxPoint.x + 1, 1));
  points.forEach((p) {
    numbers[p.y][p.x] = 8;
  });

  printArray(numbers);
}
