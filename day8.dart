import 'dart:math';

import 'package:collection/collection.dart';

import "day8_input.dart";

extension ToSet on String {
  Set<String> toSet() => this.split("").toSet();
}

extension SetEquals on Set {
  bool setEq<T>(Set<T> other) => SetEquality().equals(this, other);
}

Map<int, Set> findDigitCodes(List<String> patterns) {
  var codes = Map<int, Set>();
  var isTwo = (String p) => p.length == 5 && codes[4].difference(p.toSet()).length == 2;
  var isThree = (String p) => p.length == 5 && p.toSet().containsAll(codes[7]);
  var isFive = (String p) => p.length == 5 && codes[6].difference(p.toSet()).length == 1;
  var isSix = (String p) => p.length == 6 && codes[7].difference(p.toSet()).length == 1;
  var isNine = (String p) => p.length == 6 && p.toSet().containsAll(codes[4]);
  var isZero = (String p) => p.length == 6 && !isSix(p) && !isNine(p);

  codes[1] = patterns.firstWhere((p) => p.length == 2).toSet();
  codes[4] = patterns.firstWhere((p) => p.length == 4).toSet();
  codes[7] = patterns.firstWhere((p) => p.length == 3).toSet();
  codes[8] = patterns.firstWhere((p) => p.length == 7).toSet();
  codes[6] = patterns.firstWhere((p) => isSix(p)).toSet();
  codes[9] = patterns.firstWhere((p) => isNine(p)).toSet();
  codes[0] = patterns.firstWhere((p) => isZero(p)).toSet();
  codes[5] = patterns.firstWhere((p) => isFive(p)).toSet();
  codes[3] = patterns.firstWhere((p) => isThree(p)).toSet();
  codes[2] = patterns.firstWhere((p) => isTwo(p)).toSet();

  // print("Digit patterns found: $codes");

  return codes;
}

int countEasyDigits(List<String> inputScreens) {
  var sumOfDigits = 0;

  for (var screen in inputScreens) {
    var splitInput = screen.split(" | ");
    var patterns = splitInput.first.split(" ");
    var output = splitInput.last.split(" ");
    Map<int, Set> codes = findDigitCodes(patterns)
      ..removeWhere((key, _) => [0, 2, 3, 5, 6, 9].contains(key));

    var isKnownDigit = (String signal) {
      return codes.values.any((code) => SetEquality().equals(code, signal.split("").toSet()));
    };
    sumOfDigits += output.fold(0, (sum, signal) => isKnownDigit(signal) ? sum + 1 : sum);
  }

  print("");

  return sumOfDigits;
}

int sumOfOutput(List<String> inputScreens) {
  var sumOfAllOutput = 0;

  for (var screen in inputScreens) {
    var splitInput = screen.split(" | ");
    var patterns = splitInput.first.split(" ");
    var output = splitInput.last.split(" ");
    Map<int, Set> codes = findDigitCodes(patterns);

    var digits = output.map((letters) {
      var digit;

      // HERE BE DARGONS: This only works because keys are digits 0-9.
      for (var i = 0; i < codes.length; i++) {
        if (letters.toSet().setEq(codes[i])) {
          digit = i;
          break;
        }
      }

      return digit;
    }).toList();

    // print("Digits: $digits");

    // Map digits to a number
    var number = 0;
    var reversedDigits = digits.reversed.toList();
    for (var i = 0; i < digits.length; i++) {
      number += reversedDigits[i] * pow(10, i);
    }

    // print("Output number: $number");
    sumOfAllOutput += number;
  }

  return sumOfAllOutput;
}

void main() {
  var play = (String input) {
    var inputScreens = input.split("\n");

    print("Digits 1, 4, 7 and 8 appeared ${countEasyDigits(inputScreens)} times in the output.");
    print("Sum of all output values: ${sumOfOutput(inputScreens)}");
  };

  print("");
  print("========= TEST ==========");
  print("");
  play(day8InputTest);

  print("");
  print("========= PRODUCTION ==========");
  print("");
  play(day8Input);
}
