import 'dart:math';

import '../economy/pricing_service.dart';
import '../models/city.dart';
import '../models/npc_caravan.dart';
import '../models/world.dart';
import 'trade_opportunity.dart';

class NpcTradingService {
  static TradeOpportunity? bestTrade({
    required World world,
    required City origin,
    required NpcCaravan npc,
  }) {
    double bestProfit = 0;
    TradeOpportunity? best;

    for (final market in origin.marketGoods) {
      final spotPrice =
          PricingService.calculatePrice(
        market: market,
      );

      final affordableQuantity =
          (npc.caravan.gold / spotPrice)
              .floor();

      final remainingCargoKg =
          npc.caravan.cargoCapacityKg -
              npc.caravan.cargoWeightKg;

      final cargoLimitedQuantity =
          (remainingCargoKg /
                  market.good.weight)
              .floor();

      final quantity = min(
        market.quantity.floor(),
        min(
          affordableQuantity,
          cargoLimitedQuantity,
        ),
      );

      if (quantity <= 0) {
        continue;
      }

      for (final city in world.cities) {
        if (city == origin) {
          continue;
        }

        final sellMarket =
            city.marketForGood(
          market.good,
        );

        final cost =
            PricingService
                .transactionCost(
          market: market,
          quantity: quantity,
        );

        final revenue =
            PricingService
                .transactionRevenue(
          market: sellMarket,
          quantity: quantity,
        );

        final profit =
            revenue - cost;

        if (profit > bestProfit) {
          bestProfit = profit;

          best = TradeOpportunity(
            good: market.good,
            destination: city,
            profitPerUnit:
                profit / quantity,
          );
        }
      }
    }

    if (best != null) {
      return best;
    }

    // No profitable trade from current city.
    // Use remembered prices to relocate.

    double? lowestPrice;
    String? targetCityId;
    String? targetGoodId;

    for (final observation
        in npc.ledger.observations) {
      if (lowestPrice == null ||
          observation.price <
              lowestPrice) {
        lowestPrice =
            observation.price;
        targetCityId =
            observation.cityId;
        targetGoodId =
            observation.goodId;
      }
    }

    if (targetCityId == null ||
        targetGoodId == null) {
      return null;
    }

    final targetCity =
        world.cities.firstWhere(
      (city) =>
          city.id ==
          targetCityId,
    );

    if (targetCity == origin) {
      return null;
    }

    final good = targetCity
        .marketGoods
        .firstWhere(
          (market) =>
              market.good.id ==
              targetGoodId,
        )
        .good;

    return TradeOpportunity(
      good: good,
      destination: targetCity,
      profitPerUnit: 0,
    );
  }
}