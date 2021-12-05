import 'day4_input.dart';

class Field {
  final int number;
  bool isMarked = false;

  Field(this.number);

  @override
  String toString() {
    return "[$number, ${(isMarked ? "yes" : "no")}]";
  }
}

class Board {
  final int size;
  final List<Field> fields;

  Board(this.size, List<int> fieldNumbers) : fields = fieldNumbers.map((e) => Field(e)).toList();

  void markNumber(int number) {
    fields.where((element) => element.number == number).forEach((element) {
      element.isMarked = true;
    });
  }

  int sumOfUnmarkedFields() {
    return fields.where((field) => !field.isMarked).fold(0, (acc, field) => acc + field.number);
  }

  bool isWinning() {
    // Horizontal
    for (var rowIndex = 0; rowIndex * size < fields.length; rowIndex++) {
      var pointer = rowIndex * size;
      var row = fields.sublist(pointer, pointer + size);
      // print("ROW $row");
      if (row.every((field) => field.isMarked)) {
        return true;
      }
    }

    // Vertical
    for (var columnIndex = 0; columnIndex < size; columnIndex++) {
      var column = List.generate(size, (index) {
        return fields[columnIndex + (size * index)];
      });
      // print("COLUMN $column");
      if (column.every((field) => field.isMarked)) {
        return true;
      }
    }

    return false;
  }

  void reset() => fields.forEach((element) => element.isMarked = false);
}

class Bingo {
  final List<Board> boards;

  Bingo(List<String> rawBoards) : boards = _parseBoards(rawBoards);

  static List<Board> _parseBoards(List<String> rawBoards) {
    var boards = List<Board>();
    const boardSize = 5;
    const boardSizeWithEmptyLine = boardSize + 1;

    for (var i = 0; i * boardSizeWithEmptyLine < rawBoards.length; i++) {
      var boardPointer = i * boardSizeWithEmptyLine;
      var rawBoard = rawBoards.getRange(boardPointer, boardPointer + boardSize);
      var rawNumbers = rawBoard.join(' ').split(' ')..removeWhere((element) => element.isEmpty);
      var fields = rawNumbers.map((e) => int.parse(e.trim())).toList();
      boards.add(Board(boardSize, fields));
    }
    return boards;
  }

  int scoreFirstWiningBoard(List<int> numbers) {
    for (var number in numbers) {
      // print("NUMBER ====> $number");
      for (var board in boards) {
        board.markNumber(number);

        if (board.isWinning()) {
          // print("WINNER WINNER WINNER");
          return number * board.sumOfUnmarkedFields();
        }
      }
    }
    return 0;
  }

  void reset() {
    boards.forEach((b) => b.reset());
  }

  int scoreLastWinningBoard(List<int> numbers) {
    var losingBoards = List.from(boards);
    var lastWinningScore = 0;

    for (var number in numbers) {
      print("NUMBER ====> $number");
      losingBoards.forEach((b) => b.markNumber(number));

      var freshlyWinning = losingBoards.where((b) => b.isWinning()).toList();
      freshlyWinning.forEach((b) => losingBoards.remove(b));

      if (freshlyWinning.isNotEmpty) {
        lastWinningScore = number * freshlyWinning.last.sumOfUnmarkedFields();
      }

      losingBoards.forEach((element) {
        print("${element.fields}");
        print("");
      });
    }
    return lastWinningScore;
  }
}

void main() {
  var play = (String input) {
    var inputLines = input.split('\n').toList();
    var numbers = inputLines.first.trim().split(',').map((e) => int.parse(e)).toList();
    var boardsLines = inputLines.skip(2).toList();
    var bingo = Bingo(boardsLines);
    print("First winning board score: ${bingo.scoreFirstWiningBoard(numbers)}");
    var bingo2 = Bingo(boardsLines);
    print("Last winning board score: ${bingo2.scoreLastWinningBoard(numbers)}");
  };

  print("========= TEST ==========");
  print("");
  print("");
  play(day4TestInput);

  print("========= PRODUCTION ==========");
  print("");
  print("");
  play(day4Input);
}
