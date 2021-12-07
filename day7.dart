import "day7_input.dart";

int alignCrabs(List<int> crabPositions, {bool isFuelCostProgressive = false}) {
  var highestPosition = crabPositions.fold(0, (highest, v) => v < highest ? highest : v) + 1;
  var costList = List<int>.filled(highestPosition, 0);

  var fuelCostCalculator =
      (int currentPosition, int destination) => (destination - currentPosition).abs();

  if (isFuelCostProgressive) {
    // Arithmetic progression.
    fuelCostCalculator = (int currentPosition, int destination) {
      var diff = (destination - currentPosition).abs();
      return ((1 + diff) / 2 * diff).toInt();
    };
  }

  for (var positionIndex = 0; positionIndex < crabPositions.length; positionIndex++) {
    var position = crabPositions[positionIndex];
    for (var costIndex = 0; costIndex < costList.length; costIndex++) {
      costList[costIndex] = costList[costIndex] + fuelCostCalculator(position, costIndex);
    }

    // print("Crab at position: $position changes cost: $costList");
  }

  var minFuelCost = costList.reduce((min, v) => min < v ? min : v);

  return minFuelCost;
}

void main() {
  var play = (String input) {
    var crabs = input.split(',').map((e) => int.parse(e)).toList();
    print("Cost of cheapest alignment: ${alignCrabs(crabs)}");
    print(
        "Cost of cheapest alignment with progressive fuel cost: ${alignCrabs(crabs, isFuelCostProgressive: true)}");
  };

  print("");
  print("========= TEST ==========");
  print("");
  play(day7InputTest);

  print("");
  print("========= PRODUCTION ==========");
  print("");
  play(day7Input);
}
