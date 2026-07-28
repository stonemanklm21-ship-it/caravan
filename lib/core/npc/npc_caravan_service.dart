import 'dart:math';

import 'package:merchantcaravan/core/travel/journey_calculator.dart';

import '../economy/trading_service.dart';
import '../models/cargo_manifest_entry.dart';
import '../models/npc_caravan.dart';
import '../models/world.dart';
import 'npc_caravan_health_service.dart';
import 'npc_caravan_maintenance_service.dart';
import 'npc_caravan_supply_service.dart';
import 'npc_market_observation_service.dart';
import 'npc_trading_service.dart';
import 'npc_travel_service.dart';
import '../bandits/bandit_caravan_service.dart';
import '../models/caravan_faction.dart';
import '../models/player_state.dart';
import '../combat/encounter_service.dart';
import 'merchant_threat_service.dart';

class NpcCaravanService {
  static void clearMission(
    NpcCaravan npc,
  ) {
    npc.activeMission = null;
    npc.state = CaravanState.idle;
    npc.idleHoursRemaining = 12.0;
  }

  static void sellCargo({
    required NpcCaravan npc,
  }) {
    final city = npc.currentCity;

    if (city == null) {
      return;
    }

    final manifest =
        List<CargoManifestEntry>.from(
      npc.caravan.manifest,
    );

    for (final entry in manifest) {
      if (entry.destinationCityId !=
          city.id) {
        continue;
      }

      final inventoryItem =
          npc.caravan.inventory
              .cast<dynamic>()
              .firstWhere(
        (item) =>
            item?.good.id ==
            entry.goodId,
        orElse: () => null,
      );

      if (inventoryItem == null) {
        npc.caravan.manifest
            .remove(entry);

        continue;
      }

      final market =
          city.marketForGood(
        inventoryItem.good,
      );

      TradingService.sell(
        city: city,
        caravan: npc.caravan,
        market: market,
        quantity:
            inventoryItem.quantity
                .floor(),
      );

      npc.caravan.manifest
          .remove(entry);
    }

    npc.lastDecision =
        'Sold cargo in ${city.name}';
  }

  static void startMission({
    required NpcCaravan npc,
    required World world,
    required double worldTimeHours,
  }) {
    final city = npc.currentCity;

    if (city == null) {
      npc.lastDecision = 'No city';
      return;
    }

    final primaryMission =
        NpcTradingService.generateMission(
      world: world,
      origin: city,
      npc: npc,
      availableGold:
          npc.caravan.gold,
      availableCargoKg:
          npc.caravan.availableCapacityKg,
    );

    if (primaryMission == null) {
      final destination =
          NpcTradingService
              .randomRelocation(
        world: world,
        origin: city,
      );

      npc.lastDecision =
          'Relocating to ${destination.name}';

      npc.state =
          CaravanState.travelling;

      NpcTravelService.startJourney(
        npc: npc,
        destination: destination,
        worldTimeHours:
            worldTimeHours,
      );

      return;
    }

    npc.activeMission =
        primaryMission;

    final destination =
        primaryMission.destination;

final distance =
    JourneyCalculator.distance(
  originX: city.x,
  originY: city.y,
  destinationX:
      destination.x,
  destinationY:
      destination.y,
);

final travelHours =
    JourneyCalculator
        .travelHours(
  distance: distance,
  speed:
      npc.caravan.speed,
);

final travelDays =
    travelHours / 24;

    NpcCaravanSupplyService
        .resupplyForJourney(
      npc: npc,
      city: city,
      travelDays: travelDays,
    );

    bool boughtAnything = false;

    while (true) {
      final missions =
          NpcTradingService
              .generateMissionsForDestination(
        origin: city,
        destination:
            destination,
        npc: npc,
        availableGold:
            npc.caravan.gold,
        availableCargoKg:
            npc.caravan
                .availableCapacityKg,
      );

      if (missions.isEmpty) {
        break;
      }

      final mission =
          missions.first;

      final market =
          city.marketForGood(
        mission.good,
      );

      final bought =
          TradingService.buy(
        city: city,
        caravan: npc.caravan,
        market: market,
        quantity:
            mission.quantity,
      );

      if (!bought) {
        break;
      }

      boughtAnything = true;

      npc.caravan.manifest.add(
        CargoManifestEntry(
          goodId:
              mission.good.id,
          destinationCityId:
              destination.id,
          quantity:
              mission.quantity,
        ),
      );

      if (npc
              .caravan
              .availableCapacityKg <
          10) {
        break;
      }
    }

    if (!boughtAnything) {
      npc.activeMission = null;

      npc.lastDecision =
          'Buy failed unexpectedly';

      return;
    }

    npc.lastDecision =
        'Travelling to '
        '${destination.name}';

    npc.state =
        CaravanState.travelling;

    NpcTravelService.startJourney(
      npc: npc,
      destination: destination,
      worldTimeHours:
          worldTimeHours,
    );
  }

  static void advanceTime({
    required NpcCaravan npc,
    required World world,
    required double worldTimeHours,
    required double hours,
    required double tickFraction,
  }) {
    if (EncounterService.isInEncounter(
      npc: npc,
      world: world,
    )) {
      return;
    }


if (npc.faction ==
    CaravanFaction.merchant) {
MerchantThreatService
    .handleThreats(
  merchant: npc,
  world: world,
  worldTimeHours:
      worldTimeHours,
  tickFraction:
      tickFraction,
);
}


    switch (npc.state) {
      case CaravanState.idle:
        npc.idleHoursRemaining -=
            hours;

        if (npc.idleHoursRemaining >
            0) {
          break;
        }

        startMission(
          npc: npc,
          world: world,
          worldTimeHours:
              worldTimeHours,
        );

        break;

      case CaravanState.fleeing:
        if (npc.activeJourney !=
                null &&
            NpcTravelService
                .isComplete(
              npc: npc,
              worldTimeHours:
                  worldTimeHours,
            )) {
          NpcTravelService.arrive(
            npc: npc,
          );

          npc.state =
              CaravanState.recovering;

          npc.idleHoursRemaining =
              12;

          npc.lastDecision =
              'Recovered after fleeing';
        }

        break;

      case CaravanState.travelling:
      
        if (npc.activeJourney !=
                null &&
            NpcTravelService
                .isComplete(
              npc: npc,
              worldTimeHours:
                  worldTimeHours,
            )) {
          NpcTravelService.arrive(
            npc: npc,
          );

          NpcCaravanMaintenanceService
              .repairVehicles(
            npc: npc,
          );

          NpcCaravanHealthService
              .visitDoctor(
            npc: npc,
          );

          NpcCaravanHealthService
              .visitVet(
            npc: npc,
          );

          NpcMarketObservationService
              .observeCurrentCity(
            npc: npc,
          );

          npc.lastDecision =
              'Arrived at '
              '${npc.currentCity?.name ?? 'Unknown'}';

          npc.state =
              CaravanState.selling;
        }

        break;

      case CaravanState.selling:
        sellCargo(
          npc: npc,
        );

        clearMission(
          npc,
        );

        break;

      case CaravanState.recovering:
        npc.idleHoursRemaining -=
            hours;

        if (npc.idleHoursRemaining <=
            0) {
          final nearestCity =
              world.cities.reduce(
            (a, b) {
              final da =
                  sqrt(
                pow(
                      a.x -
                          npc.worldX,
                      2,
                    ) +
                    pow(
                      a.y -
                          npc.worldY,
                      2,
                    ),
              );

              final db =
                  sqrt(
                pow(
                      b.x -
                          npc.worldX,
                      2,
                    ) +
                    pow(
                      b.y -
                          npc.worldY,
                      2,
                    ),
              );

              return da < db
                  ? a
                  : b;
            },
          );

          npc.lastDecision =
              'Returning to ${nearestCity.name}';

          npc.state =
              CaravanState.travelling;

          NpcTravelService.startJourney(
            npc: npc,
            destination:
                nearestCity,
            worldTimeHours:
                worldTimeHours,
          );
        }

        break;

      case CaravanState.roaming:
      case CaravanState.pursuing:
        break;
    }
  }

  static void advanceAll({
    required World world,
    required PlayerState playerState,
    required double hours,
    required double tickFraction,
  }) {
    EncounterService.advance(
      world: world,
      worldTimeHours:
          playerState.worldTimeHours,
      hours: hours,
    );

    for (final npc
        in world.npcCaravans) {

      npc.surrenderProtectionHours -=
          hours;

      if (npc
              .surrenderProtectionHours <
          0) {
        npc.surrenderProtectionHours =
            0;
      }

      if (npc.faction ==
          CaravanFaction.bandit) {
        BanditCaravanService
            .advanceTime(
          npc: npc,
          world: world,
          playerState:
              playerState,
          hours: hours,
          tickFraction:
              tickFraction,
        );

        continue;
      }

      advanceTime(
        npc: npc,
        world: world,
        worldTimeHours:
            playerState
                .worldTimeHours,
        hours: hours,
        tickFraction:
            tickFraction,
      );
    }

    for (final npc
        in world.caravansToRemove) {
      world.npcCaravans.remove(
        npc,
      );
    }

    world.caravansToRemove.clear();
  }
}