import '../../data/game_data.dart';
import '../../data/quest_service_data.dart';
import '../events/city_arrived_event.dart';
import '../models/city.dart';
import '../models/player_state.dart';
import '../models/world.dart';
import '../world/location_service.dart';
import 'journey_service.dart';

class TravelService {
  static void startTravel({
    required PlayerState playerState,
    required City destination,
    double? originX,
    double? originY,
    double tickFractionOffset = 0,
  }) {
    final originCity =
        playerState.currentCity;

    playerState.currentCity = null;

    JourneyService.startJourney(
      playerState: playerState,
      destination: destination,
      originCity: originCity,
      originX: originX,
      originY: originY,
      tickFractionOffset:
          tickFractionOffset,
    );
  }

  static void startTravelToCoordinates({
    required PlayerState playerState,
    required double destinationX,
    required double destinationY,
    double? originX,
    double? originY,
    double tickFractionOffset = 0,
  }) {
    final originCity =
        playerState.currentCity;

    playerState.currentCity = null;

    JourneyService
        .startJourneyToCoordinates(
      playerState: playerState,
      originCity: originCity,
      destinationX: destinationX,
      destinationY: destinationY,
      originX: originX,
      originY: originY,
      tickFractionOffset:
          tickFractionOffset,
    );
  }

  static void enterCity({
    required PlayerState playerState,
    required City city,
  }) {
    playerState.worldX = city.x;
    playerState.worldY = city.y;
    playerState.currentCity = city;

    questService.processEvent(
      event: CityArrivedEvent(
        cityId: city.id,
      ),
      activeQuests:
          game.quests.activeQuests,
    );

    JourneyService.clearJourney(
      playerState,
    );
  }

  static void arrive({
    required PlayerState playerState,
    required World world,
  }) {
    final journey =
        playerState.activeJourney;

    if (journey == null) {
      return;
    }

    playerState.worldX =
        journey.destinationX;

    playerState.worldY =
        journey.destinationY;

    final city =
        LocationService.cityAtPosition(
      world: world,
      x: playerState.worldX,
      y: playerState.worldY,
    );

    if (city != null) {
      enterCity(
        playerState: playerState,
        city: city,
      );
    } else {
      JourneyService.clearJourney(
        playerState,
      );
    }
  }
}