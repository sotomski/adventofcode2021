import 'day2Input.dart';

class Position {
  final int horizontal;
  final int depth;

  Position(this.horizontal, this.depth);

  Position copyWith({int horizontal, int depth}) {
    return Position(
      horizontal ?? this.horizontal,
      depth ?? this.depth,
    );
  }

  @override
  String toString() {
    return "Position(horizontal = $horizontal, depth = $depth)";
  }
}

class Move {
  final String direction;
  final int distance;

  Move(this.direction, this.distance);

  @override
  String toString() {
    return "Move(direction = $direction, distance = $distance)";
  }
}

class Submarine {
  int _aim = 0;
  Position _position = Position(0, 0);

  Position get currentPosition {
    return _position;
  }

  void moveForwardBy(int distance) {
    _position = _position.copyWith(
      horizontal: _position.horizontal + distance,
      depth: _position.depth + (_aim * distance),
    );
  }

  void increaseAimBy(int value) {
    _aim += value;
  }

  void decreaseAimBy(int value) {
    _aim -= value;
  }

  void sail(List<Move> route) {
    for (var move in route) {
      switch (move.direction) {
        case 'forward':
          moveForwardBy(move.distance);
          break;

        case 'down':
          increaseAimBy(move.distance);
          break;

        case 'up':
          decreaseAimBy(move.distance);
          break;
      }
    }
  }

  @override
  String toString() {
    return "Submarine(position = $_position, aim = $_aim)";
  }
}

Position moveBy(Position initial, List<Move> moveInstructions) {
  var current = initial;

  for (var move in moveInstructions) {
    switch (move.direction) {
      case 'forward':
        current =
            current.copyWith(horizontal: current.horizontal + move.distance);
        break;

      case 'down':
        current = current.copyWith(depth: current.depth + move.distance);
        break;

      case 'up':
        current = current.copyWith(depth: current.depth - move.distance);
        break;
    }
  }

  return current;
}

void move(Submarine submarine, List<Move> instructions) {}

List<Move> parseData(String rawData) {
  return rawData.split('\n').map((e) {
    var row = e.split(' ');
    return Move(row[0], int.parse(row[1]));
  }).toList();
}

void main() {
  // print("Test input");
  // var testInstructions = parseData(day2TestInput);
  // var finalTestPosition = moveBy(Position(0, 0), testInstructions);
  // print("Test position: $finalTestPosition");

  // print("Actual task");
  // var instructions = parseData(day2Input);
  // var finalPosition = moveBy(Position(0, 0), instructions);
  // print(
  //     "Final position: $finalPosition with a result of ${finalPosition.depth * finalPosition.horizontal}");

  var testInstructions = parseData(day2TestInput);
  var testSubmarine = Submarine();
  testSubmarine.sail(testInstructions);
  print("Test submarine: $testSubmarine");

  var route = parseData(day2Input);
  var submarine = Submarine();
  submarine.sail(route);
  print("Actual submarine: $submarine");
  print(
      "Result: ${submarine.currentPosition.depth * submarine.currentPosition.horizontal}");
}
