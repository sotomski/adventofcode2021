void printArray<T>(List<List<T>> list) {
  print("");
  for (var y = 0; y < list.length; y++) {
    String line = "";
    for (var x = 0; x < list[y].length; x++) {
      line += list[y][x].toString();
    }

    print(line);
  }
}
