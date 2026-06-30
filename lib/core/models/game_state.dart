import '../travel/active_journey.dart';
import 'caravan.dart';
import 'city.dart';

class GameState {
  /// Total world time since the start of the game.
  double worldTimeHours;

  /// Current caravan position on the world map.
  double worldX;
  double worldY;

  /// Current city occupied by the player.
  City currentCity;

  /// Player caravan.
  Caravan caravan;

  /// Null when stationary.
  /// Non-null when travelling.
  ActiveJourney? activeJourney;

  GameState({
    required this.worldTimeHours,
    required this.worldX,
    required this.worldY,
    required this.currentCity,
    required this.caravan,
    this.activeJourney,
  });

  int get day => (worldTimeHours ~/ 24) + 1;

  int get hour => worldTimeHours.floor() % 24;

  bool get isTravelling =>
      activeJourney != null;
}
