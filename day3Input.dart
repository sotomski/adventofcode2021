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
    var gammeRate = _rate(report, useMostCommonBits: true);
    var epsilonRate = _rate(report, useMostCommonBits: false);

    return gammeRate * epsilonRate;
  }

  /// Prepare an abstract rating.
  ///
  /// useMostCommonBits Specifies if the most or least common bits should be selected.
  static int _rate(List<String> data, {bool useMostCommonBits}) {
    var reportNumberLength = data.first.length;
    List<String> candidates = List.from(data);
    String rateString = "";

    for (var i = 0; i < reportNumberLength; i++) {
      var positiveBitCount = _countPositiveBits(candidates);
      var half = candidates.length / 2;
      var hasMoreOnes = positiveBitCount[i] >= half;
      var selectedBit;
      if (hasMoreOnes) {
        selectedBit = useMostCommonBits ? '1' : '0';
      } else {
        selectedBit = useMostCommonBits ? '0' : '1';
      }

      // Action (accumulator?)
      rateString = rateString + selectedBit;

      // Filtering is ignored here.

      // Stop condition is ignored here.
    }

    var rate = int.parse(rateString, radix: 2);

    return rate;
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

  // print("===> Start Life support rating");
  // print("===> Life support rating: ${diagnostics.lifeSupportRating()}");
}
