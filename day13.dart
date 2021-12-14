import 'dart:math';
import 'day13_input.dart';
import 'common.dart';

List<Point<int>> buildMatrix(List<String> lines) {
  return lines.takeWhile((l) => l.isNotEmpty).map((l) {
    var coordinates = l.split(",").map((e) => int.parse(e));
    return Point<int>(coordinates.first, coordinates.last);
  }).toList();
}

List<String> buildFolds(List<String> lines) {
  return lines
      .where((l) => l.startsWith("fold along"))
      .map((l) => l.replaceAll("fold along ", ""))
      .toList();
}

Set<Point> foldManual(String foldAxis, List<Point<int>> manual) {
  List<Point<int>> foldedManual;
  var axis = foldAxis.split("=").first;
  var foldIndex = int.parse(foldAxis.split("=").last);

  if (axis == "x") {
    var foldLeft = (Point<int> p) => Point<int>(2 * foldIndex - p.x, p.y);
    foldedManual = manual.map((p) => p.x < foldIndex ? p : foldLeft(p)).toList();
  } else {
    var foldUp = (Point<int> p) => Point<int>(p.x, 2 * foldIndex - p.y);
    foldedManual = manual.map((p) => p.y < foldIndex ? p : foldUp(p)).toList();
  }

  return foldedManual.toSet();
}

void main() {
  var play = (String input) {
    var lines = input.split("\n");
    var manual = buildMatrix(lines);
    var folds = buildFolds(lines);

    var foldedManual = foldManual(folds.first, manual);
    print("${foldedManual.length} dots are visible after first fold");

    var fullFold = List<Point<int>>.from(manual);
    for (var fold in folds) {
      fullFold = foldManual(fold, fullFold).toList();
    }

    print("Full fold");
    printPoints(fullFold);
  };

  print("");
  print("========= TEST ==========");
  print("");
  play(day13InputTest);

  print("");
  print("========= PRODUCTION ==========");
  print("");
  play(day13Input);
}
