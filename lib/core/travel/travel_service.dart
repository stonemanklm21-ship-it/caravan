import '../models/city.dart';
import '../models/player_state.dart';
import 'journey_service.dart';
import '../world/location_service.dart';
import '../models/world.dart';

class TravelService {
  static void startTravel({
    required PlayerState playerState,
    required City destination,
  }) {
    JourneyService.startJourney(
      playerState: playerState,
      destination: destination,
    );
  }

  static void startTravelToCoordinates({
    required PlayerState playerState,
    required double destinationX,
    required double destinationY,
  }) {
    JourneyService.startJourneyToCoordinates(
      playerState: playerState,
      destinationX: destinationX,
      destinationY: destinationY,
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