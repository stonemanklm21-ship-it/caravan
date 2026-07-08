import '../economy/market_observation.dart';
import '../economy/pricing_service.dart';
import '../economy/trading_service.dart';
import '../models/npc_caravan.dart';
import '../models/world.dart';
import 'npc_trading_service.dart';
import 'npc_travel_service.dart';

class NpcCaravanService {
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

  static void clearMission(
    NpcCaravan npc,
  ) {
    npc.activeMission = null;
    npc.state = CaravanState.idle;
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
        npc.caravan.inventory.cast<dynamic?>().firstWhere(
      (item) => item?.good.id == mission.good.id,
      orElse: () => null,
    );

    if (inventoryItem == null) {
      return;
    }

    final market = city.marketForGood(
      mission.good,
    );

    TradingService.sell(
      city: city,
      caravan: npc.caravan,
      market: market,
      quantity: inventoryItem.quantity.floor(),
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
    );

    if (mission == null) {
      final destination =
          NpcTradingService.randomRelocation(
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
      destination: mission.destination,
    );
  }

  static void advanceTime({
    required NpcCaravan npc,
    required World world,
    required double hours,
  }) {
    switch (npc.state) {
      case CaravanState.idle:
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
            npc.activeJourney!.completed) {
          NpcTravelService.arrive(
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
    for (final npc in world.npcCaravans) {
      advanceTime(
        npc: npc,
        world: world,
        hours: hours,
      );
    }
  }
}