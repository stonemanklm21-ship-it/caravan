import 'dart:math';

import '../../data/goods_data.dart';
import '../city/animal_health_service.dart';
import '../city/person_health_service.dart';
import '../city/vehicle_repair_service.dart';
import '../economy/market_observation.dart';
import '../economy/pricing_service.dart';
import '../economy/trading_service.dart';
import '../models/city.dart';
import '../models/npc_caravan.dart';
import '../models/world.dart';
import 'npc_trading_service.dart';
import 'npc_travel_service.dart';

class NpcCaravanService {
  static final Random _random = Random();

  static void observeCurrentCity({
    required NpcCaravan npc,
  }) {
    final city = npc.currentCity;

    if (city == null) {
      return;
    }

    for (final market in city.marketGoods) {
      npc.ledger.observations.removeWhere(
        (observation) =>
            observation.cityId == city.id &&
            observation.goodId == market.good.id,
      );

      npc.ledger.observations.add(
        MarketObservation(
          cityId: city.id,
          goodId: market.good.id,
          price: PricingService.calculatePrice(
            city: city,
            market: market,
          ),
          day: 0,
          hour: 0,
        ),
      );
    }
  }

  static void repairVehicles({
    required NpcCaravan npc,
  }) {
    final city = npc.currentCity;

    if (city == null || !city.hasCartwright) {
      return;
    }

    for (final vehicle in npc.caravan.vehicles) {
      final cost =
          VehicleRepairService.repairCost(
        vehicle,
      );

      if (npc.caravan.gold >= cost) {
        npc.caravan.gold -= cost;

        VehicleRepairService.repair(
          vehicle,
        );
      }
    }
  }

  static void visitDoctor({
    required NpcCaravan npc,
  }) {
    final city = npc.currentCity;

    if (city == null || !city.hasDoctor) {
      return;
    }

    final characters = [
      npc.caravan.leader,
      ...npc.caravan.companions,
    ];

    for (final character in characters) {
      final cost =
          CharacterHealthService.healCost(
        character,
      );

      if (!CharacterHealthService.canHeal(
            character,
          ) ||
          npc.caravan.gold < cost) {
        continue;
      }

      npc.caravan.gold -= cost;

      CharacterHealthService.heal(
        character,
      );
    }
  }

  static void visitVet({
    required NpcCaravan npc,
  }) {
    final city = npc.currentCity;

    if (city == null || !city.hasVet) {
      return;
    }

    for (final animal in npc.caravan.animals) {
      final cost =
          AnimalHealthService.healCost(
        animal,
      );

      if (!AnimalHealthService.canHeal(
            animal,
          ) ||
          npc.caravan.gold < cost) {
        continue;
      }

      npc.caravan.gold -= cost;

      AnimalHealthService.heal(
        animal,
      );
    }
  }

  static void resupplyForJourney({
    required NpcCaravan npc,
    required City city,
    required double travelDays,
  }) {
    final targetDays =
        travelDays + 2;

    _buyWater(
      npc: npc,
      city: city,
      targetQuantity:
          npc.caravan.waterRequirementPerDay *
          targetDays,
    );

    _buyForage(
      npc: npc,
      city: city,
      targetQuantity:
          npc.caravan.forageRequirementPerDay *
          targetDays,
    );

    final targetCalories =
        npc.caravan.calorieRequirementPerDay *
        targetDays;

    final currentCalories =
        npc.caravan.inventory.fold<double>(
      0,
      (total, item) =>
          total +
          item.quantity *
              item.good.caloriesPerUnit,
    );

    if (currentCalories < targetCalories) {
      final caloriesNeeded =
          targetCalories -
          currentCalories;

      final breadNeeded =
          (caloriesNeeded /
                  bread.caloriesPerUnit)
              .ceil();

      TradingService.buy(
        city: city,
        caravan: npc.caravan,
        market: city.marketForGood(
          bread,
        ),
        quantity: breadNeeded,
      );
    }
  }

  static void _buyWater({
    required NpcCaravan npc,
    required City city,
    required double targetQuantity,
  }) {
    final current =
        npc.caravan.quantityOf(
      water.id,
    );

    final needed =
        (targetQuantity - current)
            .ceil();

    if (needed <= 0) {
      return;
    }

    TradingService.buy(
      city: city,
      caravan: npc.caravan,
      market: city.marketForGood(
        water,
      ),
      quantity: needed,
    );
  }

  static void _buyForage({
    required NpcCaravan npc,
    required City city,
    required double targetQuantity,
  }) {
    final current =
        npc.caravan.quantityOf(
      forage.id,
    );

    final needed =
        (targetQuantity - current)
            .ceil();

    if (needed <= 0) {
      return;
    }

    TradingService.buy(
      city: city,
      caravan: npc.caravan,
      market: city.marketForGood(
        forage,
      ),
      quantity: needed,
    );
  }

  static void clearMission(
    NpcCaravan npc,
  ) {
    npc.activeMission = null;
    npc.state = CaravanState.idle;

    npc.idleHoursRemaining =
        12.0;
  }

  static void sellCargo({
    required NpcCaravan npc,
  }) {
    final city = npc.currentCity;

    if (city == null) {
      return;
    }

    final mission = npc.activeMission;

    if (mission == null) {
      return;
    }

    final inventoryItem =
        npc.caravan.inventory
            .cast<dynamic>()
            .firstWhere(
      (item) =>
          item?.good.id ==
          mission.good.id,
      orElse: () => null,
    );

    if (inventoryItem == null) {
      return;
    }

    final market =
        city.marketForGood(
      mission.good,
    );

    TradingService.sell(
      city: city,
      caravan: npc.caravan,
      market: market,
      quantity:
          inventoryItem.quantity.floor(),
    );

    npc.lastDecision =
        'Sold ${mission.good.name} '
        'in ${city.name}';
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

    final mission =
        NpcTradingService.generateMission(
      world: world,
      origin: city,
      npc: npc,
      availableGold:
          npc.caravan.gold,
      availableCargoKg:
          npc.caravan.availableCapacityKg,
    );

    if (mission == null) {
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

    npc.activeMission = mission;

    final dx =
        mission.destination.x -
        city.x;

    final dy =
        mission.destination.y -
        city.y;

    final distance =
        sqrt(
          (dx * dx) +
              (dy * dy),
        );

    final travelDays =
        distance /
        (500 *
            npc.caravan.speed);

    resupplyForJourney(
      npc: npc,
      city: city,
      travelDays: travelDays,
    );

    final market =
        city.marketForGood(
      mission.good,
    );

    final bought = TradingService.buy(
      city: city,
      caravan: npc.caravan,
      market: market,
      quantity: mission.quantity,
    );

    if (!bought) {
      npc.activeMission = null;

      npc.lastDecision =
          'Buy failed unexpectedly';

      return;
    }

    npc.lastDecision =
        'Bought ${mission.good.name} '
        'x${mission.quantity} '
        'for ${mission.destination.name}';

    npc.state =
        CaravanState.travelling;

    NpcTravelService.startJourney(
      npc: npc,
      destination:
          mission.destination,
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

          repairVehicles(
            npc: npc,
          );

          visitDoctor(
            npc: npc,
          );

          visitVet(
            npc: npc,
          );

          observeCurrentCity(
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
      advanceTime(
        npc: npc,
        world: world,
        hours: hours,
      );
    }
  }
}