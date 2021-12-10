import 'dart:collection';

import 'day10_input.dart';

const chunkDelimiters = {"(": ")", "[": "]", "{": "}", "<": ">"};

List<String> checkLine(String line) {
  final openedChunks = Queue<String>();

  for (var i = 0; i < line.length; i++) {
    var char = line[i];
    if (chunkDelimiters.keys.contains(char)) {
      openedChunks.addFirst(char);
    } else if (chunkDelimiters.values.contains(char)) {
      // Is a chunk completed?
      var openingChar = openedChunks.removeFirst();
      if (chunkDelimiters[openingChar] != char) {
        // Line is corrupted!
        throw char;
      }
    }
  }

  // Line is complete when all chunks have been closed.
  return openedChunks.toList();
}

List<String> findIllegalChars(List<String> lines) {
  var illegalChars = List<String>();

  for (var line in lines) {
    try {
      checkLine(line);
    } catch (illegalChar) {
      illegalChars.add(illegalChar);
    }
  }

  return illegalChars;
}

int scoreChecker(List<String> illegalChars) {
  const scoreMap = {")": 3, "]": 57, "}": 1197, ">": 25137};

  return illegalChars.fold(0, (sum, char) => sum + scoreMap[char]);
}

Map<String, String> completeLines(List<String> lines) {
  var lineToCompletion = Map<String, String>();

  for (var line in lines) {
    try {
      var openedChunks = checkLine(line);
      var completion = openedChunks.map((c) => chunkDelimiters[c]).join();
      lineToCompletion[line] = completion;
    } catch (e) {
      // Discard corrupted lines.
    }
  }

  return lineToCompletion;
}

int scoreAutcompleter(Map<String, String> autocompleteOutput) {
  const scoreMap = {")": 1, "]": 2, "}": 3, ">": 4};

  var scores = autocompleteOutput.values.map((lineCompletion) {
    return lineCompletion.split("").fold(0, (acc, c) => (acc * 5) + scoreMap[c]);
  }).toList()
    ..sort();

  return scores[scores.length ~/ 2];
}

void main() {
  var play = (String input) {
    var lines = input.split("\n").toList();
    var illegalChars = findIllegalChars(lines);
    var score = scoreChecker(illegalChars);

    print("Score $score for illegal chars: \n$illegalChars");

    var completions = completeLines(lines);
    var autocompleterScore = scoreAutcompleter(completions);

    print("Score $autocompleterScore for completions: \n${completions.values}");
  };

  print("");
  print("========= TEST ==========");
  print("");
  play(day10InputTest);

  print("");
  print("========= PRODUCTION ==========");
  print("");
  play(day10Input);
}
