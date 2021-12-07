import 'day6_input.dart';

int growLanternfish(List<int> initialPopulation, int daysToLive) {
  // Naively iterate each day over each fish.
  const resetLifetime = 6;
  const newLifetime = 8;
  var population = List.from(initialPopulation);

  for (var day = 0; day < daysToLive; day++) {
    var spawnedToday = List<int>();
    for (var fishIndex = 0; fishIndex < population.length; fishIndex++) {
      var fishAge = population[fishIndex];

      if (fishAge == 0) {
        population[fishIndex] = resetLifetime;
        spawnedToday.add(newLifetime);
      } else {
        population[fishIndex] = fishAge - 1;
      }
    }

    population.addAll(spawnedToday);

    if (day % 10 == 0) {
      print("Population after day $day: ${population.length}");
    }
  }

  return population.length;
}

int growFishFast(List<int> initialPopulation, int daysToLive) {
  // Keep count of population ages only.
  var population = {0: 0, 1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0, 7: 0, 8: 0};

  for (var i = 0; i < initialPopulation.length; i++) {
    population.update(initialPopulation[i], (count) => count + 1);
  }

  for (var day = 0; day < daysToLive; day++) {
    var newSpawn = population[0];

    population[0] = population[1];
    population[1] = population[2];
    population[2] = population[3];
    population[3] = population[4];
    population[4] = population[5];
    population[5] = population[6];
    population[6] = population[7] + newSpawn;
    population[7] = population[8];
    population[8] = newSpawn;

    // print("Population after day $day: $population");
  }

  return population.values.fold(0, (acc, v) => acc + v);
}

void main() {
  var play = (String input) {
    var population = input.split(',').map((e) => int.parse(e)).toList();
    // print("Population count after 80 days: ${growLanternfish(population, 80)}");
    print(
        "Fast population count after 80 days: ${growFishFast(population, 80)}");
    // print(
    //     "Population count after 256 days: ${growLanternfish(population, 256)}");
    print(
        "Fast population count after 256 days: ${growFishFast(population, 256)}");
  };

  print("");
  print("========= TEST ==========");
  print("");
  play(day6InputTest);

  print("");
  print("========= PRODUCTION ==========");
  print("");
  play(day6Input);
}
