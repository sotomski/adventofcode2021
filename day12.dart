import 'day12_input.dart';
import 'common.dart';

class Cave {
  final String name;
  final List<Cave> connections = List();
  bool isVisited = false;

  Cave(this.name);

  bool get isLarge => name == name.toUpperCase();
}

List<String> buildCavesList(String input) {
  var lines = input.split("\n");
  var caves = Set<String>();

  lines.forEach((line) {
    line.split("-").forEach((c) => caves.add(c));
  });

  // Ensure start is first.
  return caves.toList()
    ..remove("start")
    ..insert(0, "start")
    ..remove("end")
    ..add("end");
}

List<List<int>> buildCaveConnections(String input, List<String> caveList) {
  List<List<int>> connections = List.generate(caveList.length, (index) {
    return List.generate(caveList.length, (index) => 0);
  });

  input.split("\n").forEach((line) {
    var conn = line.split("-");
    var leftIdx = caveList.indexOf(conn.first);
    var rightIdx = caveList.indexOf(conn.last);
    connections[leftIdx][rightIdx] = 1;
    connections[rightIdx][leftIdx] = 1;
  });
  return connections;
}

bool isSmallAndVisited(String caveName, List<String> pathUntilNow) {
  return caveName == caveName.toLowerCase() && pathUntilNow.contains(caveName);
}

bool hasMultipleSmallCavesVisitedTwice(
    String caveName, List<String> pathUntilNow) {
  var pathWithNewCave = List.from(pathUntilNow)..add(caveName);
  var smallsList = pathWithNewCave.where((p) => p == p.toLowerCase());
  var smallsSet = smallsList.toSet();

  return smallsList.length - smallsSet.length > 1;
}

List<List<String>> findPathToEnd(
  List<String> pathUntilNow,
  List<String> caveList,
  List<List<int>> caveConnections,
  bool Function(String, List<String>) isInvalidC,
) {
  // Get adjacent caves
  var lastCaveIndex = caveList.indexOf(pathUntilNow.last);
  var connections = caveConnections[lastCaveIndex];
  var pathsFound = List<List<String>>();

  for (var maybeConnIdx = 0;
      maybeConnIdx < connections.length;
      maybeConnIdx++) {
    // A connection is only there if matrix holds 1 at our position.
    if (connections[maybeConnIdx] == 1) {
      var connName = caveList[maybeConnIdx];

      if (connName == "end") {
        // Path finished!
        pathsFound.add(["end"]);
      } else if (connName != "start" && !isInvalidC(connName, pathUntilNow)) {
        // Path continues
        var newUntilNow = List<String>.from(pathUntilNow)..add(connName);
        var subPaths =
            findPathToEnd(newUntilNow, caveList, caveConnections, isInvalidC);
        pathsFound.addAll(subPaths.map((p) => p..insert(0, connName)));
      }
    }
  }

  return pathsFound;
}

List<String> findAllPathsVisitingSmallOnce(
  List<String> caveList,
  List<List<int>> caveConnections,
) {
  var paths =
      findPathToEnd(["start"], caveList, caveConnections, isSmallAndVisited)
          .map((path) => path..insert(0, "start"))
          .toList();

  return paths.map((p) => p.join(",")).toList();
}

List<String> findAllPathsVisitingSingleSmallTwice(
  List<String> caveList,
  List<List<int>> caveConnections,
) {
  var paths = findPathToEnd(["start"], caveList, caveConnections,
          hasMultipleSmallCavesVisitedTwice)
      .map((path) => path..insert(0, "start"))
      .toList();

  return paths.map((p) => p.join(",")).toSet().toList();
}

void main() {
  var play = (String input) {
    var caveList = buildCavesList(input);
    var caveConnections = buildCaveConnections(input, caveList);

    print("Caves:");
    print("$caveList");
    print("");
    print("Connections:");
    printArray(caveConnections);

    var paths = findAllPathsVisitingSmallOnce(caveList, caveConnections);
    print("");
    print("${paths.length} paths with small caves visited only once");
    // print("$paths");

    var morePaths =
        findAllPathsVisitingSingleSmallTwice(caveList, caveConnections);
    print("");
    print(
        "${morePaths.length} paths with a single small cave visited at most twice");
    // print("$morePaths");
  };

  print("");
  print("========= TEST ==========");
  print("");
  play(day12InputTest3);

  print("");
  print("========= PRODUCTION ==========");
  print("");
  play(day12Input);
}
