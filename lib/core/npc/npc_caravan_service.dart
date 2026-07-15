import 'dart:math';

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
      );

      return;
    }

    npc.activeMission =
        primaryMission;

    final destination =
        primaryMission.destination;

    final dx =
        destination.x - city.x;

    final dy =
        destination.y - city.y;

    final distance =
        sqrt(
          (dx * dx) +
              (dy * dy),
        );

    final travelDays =
        distance /
        (500 *
            npc.caravan.speed);

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
    );
  }

  static void advanceTime({
    required NpcCaravan npc,
    required World world,
    required double hours,
  }) {
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
        );

        break;

      case CaravanState.travelling:
        NpcTravelService.advanceJourney(
          npc: npc,
          hours: hours,
        );

        if (npc.activeJourney != null &&
            npc.activeJourney!
                .completed) {
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
    }
  }

static void advanceAll({
  required World world,
  required double hours,
}) {
  for (final npc
      in world.npcCaravans) {
    if (npc.faction ==
        CaravanFaction.bandit) {
      BanditCaravanService
          .advanceTime(
        npc: npc,
        world: world,
        hours: hours,
      );

      continue;
    }

    advanceTime(
      npc: npc,
      world: world,
      hours: hours,
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