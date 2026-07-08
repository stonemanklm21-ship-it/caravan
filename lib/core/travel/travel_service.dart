import '../models/city.dart';
import '../models/player_state.dart';
import 'journey_service.dart';
import '../world/location_service.dart';
import '../models/world.dart';

class TravelService {
  static void startTravel({
    required PlayerState playerState,
    required City destination,
    double? originX,
    double? originY,
    double tickFractionOffset = 0,
  }) {
    playerState.currentCity = null;

    JourneyService.startJourney(
      playerState: playerState,
      destination: destination,
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
    playerState.currentCity = null;

    JourneyService
        .startJourneyToCoordinates(
      playerState: playerState,
      destinationX: destinationX,
      destinationY: destinationY,
      originX: originX,
      originY: originY,
      tickFractionOffset:
          tickFractionOffset,
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

    playerState.currentCity =
        LocationService.cityAtPosition(
      world: world,
      x: playerState.worldX,
      y: playerState.worldY,
    );

    JourneyService.clearJourney(
      playerState,
    );
  }
}