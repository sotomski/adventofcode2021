import 'dart:math';

import 'day9_input.dart';
import 'common.dart';

int cumulativeRiskLevel(List<List<int>> map) {
  List<int> lowPoints = List();

  for (var y = 0; y < map.length; y++) {
    for (var x = 0; x < map[y].length; x++) {
      var point = map[y][x];
      var neighbours = List();

      // Left
      if (x > 0) {
        neighbours.add(map[y][x - 1]);
      }

      // Top
      if (y > 0) {
        neighbours.add(map[y - 1][x]);
      }

      // Right
      if (x < map[y].length - 1) {
        neighbours.add(map[y][x + 1]);
      }

      // Bottom
      if (y < map.length - 1) {
        neighbours.add(map[y + 1][x]);
      }

      if (neighbours.every((n) => n > point)) {
        lowPoints.add(point);
      }
    }
  }

  print("Low points found: $lowPoints");

  return lowPoints.fold(0, (acc, p) => acc + p + 1);
}

void exploreBasin(List<List<PointValue>> map, Point start, Set<Point> basin) {
  // print("Explored point: $start with value ${map[start.y][start.x]}");
  // print("Basin: $basin");

  if (map[start.y][start.x].isVisited) {
    return;
  }

  map[start.y][start.x].isVisited = true;
  basin.add(start);

  if (start.x > 0) {
    exploreBasin(map, Point(start.x - 1, start.y), basin);
  }
  if (start.y > 0) {
    exploreBasin(map, Point(start.x, start.y - 1), basin);
  }
  if (start.x < map[start.y].length - 1) {
    exploreBasin(map, Point(start.x + 1, start.y), basin);
  }
  if (start.y < map.length - 1) {
    exploreBasin(map, Point(start.x, start.y + 1), basin);
  }
}

class PointValue {
  var isVisited;
  final int value;

  PointValue(this.value, this.isVisited);

  @override
  String toString() {
    return "($value; $isVisited)";
  }
}

int findLargestBasins(List<List<int>> map) {
  const basinDelimiter = 9;
  List<List<int>> allBasins = List();
  Set<Point> tempBasin = Set();

  List<List<PointValue>> betterMap = List.generate(map.length, (index) => List(map.first.length));

  // Construct a better map.
  for (var y = 0; y < map.length; y++) {
    for (var x = 0; x < map[y].length; x++) {
      betterMap[y][x] = PointValue(map[y][x], map[y][x] == basinDelimiter);
    }
  }

  // printArray(map);
  // printArray(betterMap);

  for (var y = 0; y < map.length; y++) {
    for (var x = 0; x < map[y].length; x++) {
      // print("==== NEW BASIN SEARCH ====");

      exploreBasin(betterMap, Point(x, y), tempBasin);

      if (tempBasin.isNotEmpty) {
        allBasins.add(tempBasin.map((p) => map[p.y][p.x]).toList());
        tempBasin.clear();
      }
    }
  }

  // print("Basins found: $allBasins");
  allBasins.sort((left, right) => right.length.compareTo(left.length));

  return allBasins.take(3).fold(1, (product, basin) => product * basin.length);
}

void main() {
  var play = (String input) {
    var heightmap =
        input.split("\n").map((line) => line.split("").map((e) => int.parse(e)).toList()).toList();

    print("Cumulative risk level: ${cumulativeRiskLevel(heightmap)}");
    print("Product of 3 largest basins' sizes: ${findLargestBasins(heightmap)}");
  };

  print("");
  print("========= TEST ==========");
  print("");
  play(day9InputTest);

  print("");
  print("========= PRODUCTION ==========");
  print("");
  play(day9Input);
}
