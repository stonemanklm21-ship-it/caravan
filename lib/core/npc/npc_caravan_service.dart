import 'dart:math';

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
            observation.cityId ==
                city.id &&
            observation.goodId ==
                market.good.id,
      );

      npc.ledger.observations.add(
        MarketObservation(
          cityId: city.id,
          goodId: market.good.id,
          price:
              PricingService
                  .calculatePrice(
            market: market,
          ),
          day: 0,
          hour: 0,
        ),
      );
    }
  }

  static void tradeAndDepart({
    required NpcCaravan npc,
    required World world,
  }) {
    final city = npc.currentCity;

    if (city == null) {
      return;
    }

    final trade =
        NpcTradingService.bestTrade(
      world: world,
      origin: city,
      npc: npc,
    );

    if (trade == null) {
      return;
    }

    final market =
        city.marketForGood(
      trade.good,
    );

    final price =
        PricingService.calculatePrice(
      market: market,
    );

    final affordableQuantity =
        (npc.caravan.gold / price)
            .floor();

    final availableQuantity =
        market.quantity.floor();

    final remainingCargoKg =
        npc.caravan.cargoCapacityKg -
            npc.caravan.cargoWeightKg;

    final cargoLimitedQuantity =
        (remainingCargoKg /
                market.good.weight)
            .floor();

    final quantity = min(
      affordableQuantity,
      min(
        availableQuantity,
        cargoLimitedQuantity,
      ),
    );

    if (quantity <= 0) {
      return;
    }

    final bought =
        TradingService.buy(
      caravan: npc.caravan,
      market: market,
      quantity: quantity,
    );

    if (!bought) {
      return;
    }

    NpcTravelService.startJourney(
      npc: npc,
      destination: trade.destination,
    );
  }

  static void advanceTime({
    required NpcCaravan npc,
    required World world,
    required double hours,
  }) {
    if (npc.activeJourney == null) {
      tradeAndDepart(
        npc: npc,
        world: world,
      );
      return;
    }

    NpcTravelService.advanceJourney(
      npc: npc,
      hours: hours,
    );

    if (npc.activeJourney != null &&
        npc.activeJourney!.completed) {
      final destination =
          npc.activeJourney!
              .destinationCity;

      NpcTravelService.arrive(
        npc: npc,
      );

      observeCurrentCity(
        npc: npc,
      );

      if (destination != null) {
        for (final item
            in npc.caravan.inventory
                .toList()) {
          final market =
              destination.marketForGood(
            item.good,
          );

          TradingService.sell(
            caravan: npc.caravan,
            market: market,
            quantity:
                item.quantity.floor(),
          );
        }
      }

      tradeAndDepart(
        npc: npc,
        world: world,
      );
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