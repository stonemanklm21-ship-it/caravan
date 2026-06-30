import '../models/city.dart';
import '../models/game_state.dart';
import 'journey_service.dart';

class TravelService {
  static void startTravel({
    required GameState gameState,
    required City destination,
  }) {
    JourneyService.startJourney(
      gameState: gameState,
      destination: destination,
    );
  }

  static void arrive({
    required GameState gameState,
    required City destination,
  }) {
    gameState.worldX = destination.x;
    gameState.worldY = destination.y;

    gameState.currentCity = destination;

    JourneyService.clearJourney(
      gameState,
    );
  }
}