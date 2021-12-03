import 'day3.dart';

class Diagnostics {
  final List<String> report;

  Diagnostics(this.report);

  static List<int> _countPositiveBits(List<String> report) {
    List<int> positiveBitCount = List.filled(report.first.length, 0);

    // Sum all ones
    report.forEach((item) {
      var bits = item.split('');
      for (var i = 0; i < bits.length; i++) {
        if (bits[i] == '1') {
          positiveBitCount[i]++;
        }
      }
    });

    return positiveBitCount;
  }

  int powerConsumption() {
    var gammaRateString = "";
    var epsilonRateString = "";
    var positiveBitCount = _countPositiveBits(report);
    var half = report.length ~/ 2;

    for (var i = 0; i < positiveBitCount.length; i++) {
      if (positiveBitCount[i] > half) {
        gammaRateString = gammaRateString + "1";
        epsilonRateString = epsilonRateString + "0";
      } else {
        gammaRateString = gammaRateString + "0";
        epsilonRateString = epsilonRateString + "1";
      }
    }

    var gammaRate = int.parse(gammaRateString, radix: 2);
    var epsilonRate = int.parse(epsilonRateString, radix: 2);

    print("Gamma rate string: $gammaRateString");
    print("Gamme rate decimal: $gammaRate");
    print("Epsilon rate string: $epsilonRateString");
    print("Epsilon rate decimal: $epsilonRate");

    return gammaRate * epsilonRate;
  }

  int oxygeneGeneratorRating() {
    var reportNumberLength = report.first.length;
    List<String> candidates = List.from(report);
    var ratingString;
    int rating;

    for (var i = 0; i < reportNumberLength; i++) {
      var positiveBitCount = _countPositiveBits(candidates);
      var half = candidates.length / 2;
      var retainBit = positiveBitCount[i] >= half ? '1' : '0';

      print("Positive bit count: $positiveBitCount with retain bit $retainBit for $candidates");

      candidates.retainWhere((element) => element.split('')[i] == retainBit);

      print("Remaining candidates: $candidates");

      if (candidates.length == 1) {
        ratingString = candidates.first;
        break;
      }
    }

    rating = int.parse(ratingString, radix: 2);

    return rating;
  }

  int co2ScurbberRating() {
    var reportNumberLength = report.first.length;
    List<String> candidates = List.from(report);
    var ratingString;
    int rating;

    for (var i = 0; i < reportNumberLength; i++) {
      var positiveBitCount = _countPositiveBits(candidates);
      var half = candidates.length / 2;
      var retainBit = positiveBitCount[i] >= half ? '0' : '1';

      print("Positive bit count: $positiveBitCount with retain bit $retainBit for $candidates");

      candidates.retainWhere((element) => element.split('')[i] == retainBit);

      print("Remaining candidates: $candidates");

      if (candidates.length == 1) {
        ratingString = candidates.first;
        break;
      }
    }

    rating = int.parse(ratingString, radix: 2);

    return rating;
  }

  int lifeSupportRating() {
    return oxygeneGeneratorRating() * co2ScurbberRating();
  }
}

void main() {
  print("============= Test ================");
  print("");
  print("");
  var testReport = day3TestInput.split('\n').map((e) => e.trim()).toList();
  var testDiagnostics = Diagnostics(testReport);
  var testPowerConsumption = testDiagnostics.powerConsumption();
  print("===> Test power consumption: $testPowerConsumption");

  print("===> Start Life support rating");
  var testLifeSupportRating = testDiagnostics.lifeSupportRating();
  print("===> Test life support rating: $testLifeSupportRating");

  print("");
  print("");
  print("============= Production ================");
  print("");
  print("");
  var report = day3Input.split('\n').map((e) => e.trim()).toList();
  var diagnostics = Diagnostics(report);
  var powerConsumption = diagnostics.powerConsumption();
  print("===> Power consumption: $powerConsumption");

  print("===> Start Life support rating");
  print("===> Life support rating: ${diagnostics.lifeSupportRating()}");
}
