import '../caravan/animal_service.dart';
import '../caravan/vehicle_service.dart';
import '../caravan/death_service.dart';
import '../economy/economy_service.dart';
import '../models/player_state.dart';
import '../models/world.dart';
import '../npc/npc_caravan_service.dart';
import '../travel/consumption_service.dart';
import '../travel/discovery_service.dart';
import '../travel/journey_service.dart';
import '../travel/travel_service.dart';
import '../world/location_service.dart';
import '../world/npc_population_service.dart';
import '../../data/game_balance.dart';
import '../models/caravan_faction.dart';
import '../caravan/skill_service.dart';
import '../models/skill.dart';

class TimeService {
  static void advanceTime({
    required PlayerState playerState,
    required World world,
    required double hours,
    required double tickFraction,
  }) {
    EconomyService.advanceTime(
      world: world,
      hours: hours,
    );

playerState.worldTimeHours += hours;

if (playerState.banditProtectionHours >
    0) {
  playerState.banditProtectionHours -=
      hours;

  if (playerState.banditProtectionHours <
      0) {
    playerState.banditProtectionHours =
        0;
  }
}
if (playerState.activeJourney != null) {
  SkillService.addSharedXp(
    characters: [
      playerState.caravan.leader,
      ...playerState.caravan.companions,
    ],
    skill: Skill.scout,
    amount: hours * GameBalance.scoutXpPerTravelHour,
  );
}

NpcCaravanService.advanceAll(
      world: world,
      hours: hours,
      playerState: playerState,
      tickFraction: tickFraction,
    );

    ConsumptionService.consume(
      caravan: playerState.caravan,
      days: hours / 24,
    );

    AnimalService.advanceTimeForAll(
      animals: playerState.caravan.animals,
      hours: hours,
    );

    if (playerState.activeJourney != null) {
      VehicleService.advanceTimeForAll(
        caravan: playerState.caravan,
        vehicles:
            playerState.caravan.vehicles,
        hours: hours,
      );
    }

    for (final npc in world.npcCaravans) {
      final days = hours / 24;

      if (npc.faction ==
          CaravanFaction.bandit) {
        npc.caravan.gold *=
            (1 -
                (GameBalance
                        .banditDailyGoldDecay *
                    days));

        if (npc.caravan.gold < 1) {
          npc.caravan.gold = 0;
        }
      }

      if (npc.faction !=
          CaravanFaction.bandit) {
        ConsumptionService.consume(
          caravan: npc.caravan,
          days: days,
        );
      }

      AnimalService.advanceTimeForAll(
        animals: npc.caravan.animals,
        hours: hours,
      );

      if (npc.activeJourney != null) {
        VehicleService.advanceTimeForAll(
          caravan: npc.caravan,
          vehicles:
              npc.caravan.vehicles,
          hours: hours,
        );
      }
    }

    bool enteredCity = false;

    if (playerState.activeJourney != null) {
      final startHour =
          playerState.worldTimeHours -
              hours;

      final endHour =
          playerState.worldTimeHours;

      final journey =
          playerState.activeJourney;

      final startProgress =
          journey!.progressAt(
        startHour,
      );

      final endProgress =
          journey.progressAt(
        endHour,
      );

      final startX =
          journey.originX +
              ((journey.destinationX -
                      journey.originX) *
                  startProgress);

      final startY =
          journey.originY +
              ((journey.destinationY -
                      journey.originY) *
                  startProgress);

      final endX =
          journey.originX +
              ((journey.destinationX -
                      journey.originX) *
                  endProgress);

      final endY =
          journey.originY +
              ((journey.destinationY -
                      journey.originY) *
                  endProgress);

      for (final city in world.cities) {
        if (city ==
            journey.originCity) {
          continue;
        }

        if (LocationService
            .segmentIntersectsCity(
          startX: startX,
          startY: startY,
          endX: endX,
          endY: endY,
          city: city,
        )) {
          TravelService.enterCity(
            playerState: playerState,
            city: city,
          );

          enteredCity = true;
          break;
        }
      }

      if (!enteredCity &&
          JourneyService.isComplete(
            playerState,
          )) {
        TravelService.arrive(
          world: world,
          playerState: playerState,
        );
      }
    }

    final currentHour =
        playerState.worldTimeHours.floor();

    if (currentHour -
            world
                .lastPopulationMaintenanceHour >=
        GameBalance
            .populationMaintenanceHours) {
      NpcPopulationService.maintain(
        world,
      );

      world.lastPopulationMaintenanceHour =
          currentHour;
    }

DeathService.processPlayer(
  playerState: playerState,
);

DeathService.processWorld(
  world: world,
);


    DiscoveryService
        .discoverNearbyCities(
      playerState: playerState,
      world: world,
    );
  }
}