import 'dart:math';

import 'day11_input.dart';
import 'common.dart';

void increaseEnergyLevel(List<List<int>> octopuses) {
  for (var y = 0; y < octopuses.length; y++) {
    for (var x = 0; x < octopuses[y].length; x++) {
      octopuses[y][x] += 1;
    }
  }
}

void resetFlashed(List<List<int>> octopuses, int flashMark) {
  for (var y = 0; y < octopuses.length; y++) {
    for (var x = 0; x < octopuses[y].length; x++) {
      if (octopuses[y][x] == flashMark) {
        octopuses[y][x] = 0;
      }
    }
  }
}

List<Point<int>> neighbours(Point position, Point size) {
  var neighboursFound = List<Point<int>>();

  if (0 < position.x) {
    // left
    neighboursFound.add(Point(position.x - 1, position.y));
  }
  if (0 < position.x && 0 < position.y) {
    // top left
    neighboursFound.add(Point(position.x - 1, position.y - 1));
  }
  if (0 < position.y) {
    // top
    neighboursFound.add(Point(position.x, position.y - 1));
  }
  if (position.x < size.x - 1 && 0 < position.y) {
    // top right
    neighboursFound.add(Point(position.x + 1, position.y - 1));
  }
  if (position.x < size.x - 1) {
    // right
    neighboursFound.add(Point(position.x + 1, position.y));
  }
  if (position.x < size.x - 1 && position.y < size.y - 1) {
    // bottom right
    neighboursFound.add(Point(position.x + 1, position.y + 1));
  }
  if (position.y < size.y - 1) {
    // bottom
    neighboursFound.add(Point(position.x, position.y + 1));
  }
  if (0 < position.x && position.y < size.y - 1) {
    // bottom left
    neighboursFound.add(Point(position.x - 1, position.y + 1));
  }

  return neighboursFound;
}

int flashesInStep(
  List<List<int>> octopuses,
  Point<int> position,
  int flashMark,
) {
  // Perform one step and return count of flashes.
  var shhouldFlash = octopuses[position.y][position.x] > 9;
  var affectedNeighbours = List<Point<int>>();
  var size = Point(octopuses[position.y].length, octopuses.length);

  if (shhouldFlash) {
    octopuses[position.y][position.x] = flashMark;
    affectedNeighbours = neighbours(position, size);

    // Increase energy levels of non-flashing neighbours.
    affectedNeighbours.forEach((p) {
      if (octopuses[p.y][p.x] != flashMark) {
        octopuses[p.y][p.x] += 1;
      }
    });

    var neighbourFlashesCount =
        affectedNeighbours.map((n) => flashesInStep(octopuses, n, flashMark));
    return 1 + neighbourFlashesCount.fold(0, (sum, n) => sum + n);
  } else {
    return 0;
  }
}

int simulateFlashes(List<List<int>> octopuses) {
  // Copy input to preserve its state.
  List<List<int>> internalOctopuses = List.generate(octopuses.length, (i) {
    return List.from(octopuses[i]);
  });
  const stepNumber = 100;
  const flashMark = -1;
  var flashCount = 0;

  for (var i = 0; i < stepNumber; i++) {
    increaseEnergyLevel(internalOctopuses);

    for (var y = 0; y < internalOctopuses.length; y++) {
      for (var x = 0; x < internalOctopuses[y].length; x++) {
        flashCount += flashesInStep(internalOctopuses, Point(x, y), flashMark);
      }
    }

    resetFlashed(internalOctopuses, flashMark);

    if (i < 10 || i % 10 == 0) printArray(internalOctopuses);
  }

  return flashCount;
}

void main() {
  var play = (String input) {
    List<List<int>> octopuses = input.split("\n").map((line) {
      return line.split("").map((e) => int.parse(e)).toList();
    }).toList();

    print("Flashes after 100 steps: ${simulateFlashes(octopuses)}");
  };

  print("");
  print("========= TEST ==========");
  print("");
  play(day11InputTest);

  print("");
  print("========= PRODUCTION ==========");
  print("");
  play(day11Input);
}
