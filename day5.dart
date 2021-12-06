import 'dart:math';

import 'day5_input.dart';

Map<Point, int> prepareVentMap(List<List<Point<int>>> lines) {
  var ventMap = Map<Point, int>();

  // Figure out all points on the line.
  for (var line in lines) {
    bool isDiagonal = line.first.x != line.last.x && line.first.y != line.last.y;
    bool isVertical = line.first.x == line.last.x && line.first.y != line.last.y;
    var verticalSign = line.first.y < line.last.y ? 1 : -1;
    var horizontalSign = line.first.x < line.last.x ? 1 : -1;
    var length;
    var diff = line.first - line.last;

    if (isDiagonal) {
      length = diff.x.abs().toInt() + 1;
    } else {
      length = diff.magnitude.toInt() + 1;
    }

    var linePoints = List.generate(length, (index) {
      if (isDiagonal) {
        return Point(
            line.first.x + (horizontalSign * index), line.first.y + (verticalSign * index));
      } else if (isVertical) {
        return Point(line.first.x, line.first.y + (verticalSign * index));
      } else {
        // Assumed horizontal
        return Point(line.first.x + (horizontalSign * index), line.first.y);
      }
    });

    // print("-----------------------------");
    // print("Length: $length");
    // print("Line: $line");
    // print("Points: $linePoints");

    // Add points to map.
    linePoints.forEach((p) {
      ventMap.update(p, (v) => v + 1, ifAbsent: () => 1);
    });

    // print("Map snapshot: $ventMap");
  }

  return ventMap;
}

int findDangerousAreas(Map<Point, int> ventMap) {
  return ventMap.values.where((v) => v > 1).fold(0, (acc, e) => acc + 1);
}

void main() {
  var play = (String input) {
    var inputLines = input.split('\n').toList();
    List<List<Point<int>>> lines = inputLines.map((line) {
      return line.split(" -> ").map((inputPoint) {
        var inputCoordinates = inputPoint.split(",").toList();
        return Point(int.parse(inputCoordinates.first), int.parse(inputCoordinates.last));
      }).toList();
    }).toList();
    var filteredLines = lines
        .where((points) => points.first.x == points.last.x || points.first.y == points.last.y)
        .toList();

    var ventMap = prepareVentMap(filteredLines);
    print("Non-diagonal dangerous areas found: ${findDangerousAreas(ventMap)}");

    print("");

    var ventMapWithDiagonals = prepareVentMap(lines);
    print("Diagonal dangerous areas found: ${findDangerousAreas(ventMapWithDiagonals)}");
  };

  print("");
  print("========= TEST ==========");
  print("");
  play(day5InputTest);

  print("");
  print("========= PRODUCTION ==========");
  print("");
  play(day5Input);
}
