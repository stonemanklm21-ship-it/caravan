class WorldMapCoordinates {
  static String eastWest(double x) {
    if (x >= 0) {
      return '${x.round()} E';
    }

    return '${x.abs().round()} W';
  }

  static String northSouth(double y) {
    if (y <= 0) {
      return '${y.abs().round()} N';
    }

    return '${y.round()} S';
  }
}