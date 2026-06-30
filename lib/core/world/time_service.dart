import '../economy/economy_service.dart';
import '../models/game_state.dart';
import '../models/world.dart';
import '../travel/consumption_service.dart';
import '../travel/journey_service.dart';
import '../travel/travel_service.dart';

class TimeService {
  static void advanceTime({
    required GameState gameState,
    required World world,
    required double hours,
  }) {
    EconomyService.advanceTime(
      world: world,
      hours: hours,
    );

    ConsumptionService.consume(
      caravan: gameState.caravan,
      days: hours / 24,
    );

    JourneyService.advanceJourney(
      gameState: gameState,
      hours: hours,
    );

    final activeJourney =
        gameState.activeJourney;

    if (
      activeJourney != null &&
      activeJourney.completed
    ) {
      TravelService.arrive(
        gameState: gameState,
        destination: activeJourney.destination,
      );
    }

    gameState.worldTimeHours += hours;
  }
}