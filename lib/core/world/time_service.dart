import '../caravan/animal_service.dart';
import '../caravan/vehicle_service.dart';
import '../economy/economy_service.dart';
import '../models/player_state.dart';
import '../models/world.dart';
import '../npc/npc_caravan_service.dart';
import '../travel/consumption_service.dart';
import '../travel/discovery_service.dart';
import '../travel/journey_service.dart';
import '../travel/travel_service.dart';

class TimeService {
  static void advanceTime({
    required PlayerState playerState,
    required World world,
    required double hours,
  }) {
    EconomyService.advanceTime(
      world: world,
      hours: hours,
    );

    NpcCaravanService.advanceAll(
      world: world,
      hours: hours,
    );

    AnimalService.advanceTimeForAll(
      animals: playerState.caravan.animals,
      hours: hours,
    );

    VehicleService.advanceTimeForAll(
      caravan: playerState.caravan,
      vehicles: playerState.caravan.vehicles,
      hours: hours,
    );

    for (final npc
        in world.npcCaravans) {
      AnimalService.advanceTimeForAll(
        animals: npc.caravan.animals,
        hours: hours,
      );

      VehicleService.advanceTimeForAll(
        caravan: npc.caravan,
        vehicles: npc.caravan.vehicles,
        hours: hours,
      );
    }

    ConsumptionService.consume(
      caravan: playerState.caravan,
      days: hours / 24,
    );

    JourneyService.advanceJourney(
      playerState: playerState,
      hours: hours,
    );

    final activeJourney =
        playerState.activeJourney;

    if (activeJourney != null &&
        activeJourney.completed) {
      TravelService.arrive(
        world: world,
        playerState: playerState,
      );
    }

    playerState.worldTimeHours += hours;

    DiscoveryService.discoverNearbyCities(
      playerState: playerState,
      world: world,
    );
  }
}