import 'day1input1.dart';
import 'day1input2.dart';

int countDepthIncrease(List<int> sonarSweep) {
  int increaseCount = 0;
  int prevSweepValue = sonarSweep.first;

  for (var sweepValue in sonarSweep.skip(1)) {
    if (prevSweepValue < sweepValue) {
      increaseCount++;
    }
    prevSweepValue = sweepValue;
  }

  return increaseCount;
}

const testMeasurements = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263];

List<int> measurements = day1Input1.split('\n').map((e) => int.parse(e)).toList();

List<int> denoiseSonarSweep(int windowSize, List<int> rawData) {
  List<int> sums = [];

  for (var i = 0; i <= rawData.length - windowSize; i++) {
    var slice = rawData.sublist(i, i + windowSize);
    sums.add(slice.fold(0, (previousValue, element) => previousValue + element));
  }

  return sums;
}

void main() {
  var processData = (window, data) {
    print(countDepthIncrease(denoiseSonarSweep(window, data)));
  };

  processData(1, testMeasurements);
  processData(1, measurements);

  var rawData2 = day1Input2.split('\n').map((e) => int.parse(e)).toList();
  processData(3, rawData2);
}
