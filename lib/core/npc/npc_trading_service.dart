import 'dart:math';

import '../economy/pricing_service.dart';
import '../models/city.dart';
import '../models/market_good.dart';
import '../models/npc_caravan.dart';
import '../models/trade_mission.dart';
import '../models/world.dart';

class NpcTradingService {
  /// Maximum proportion of a market's stock
  /// a caravan may buy in one transaction.
  static const double maxMarketShare = 0.10;

  /// Maximum proportion of available gold
  /// a caravan may commit to a trade.
  static const double maxGoldShare = 0.25;

  /// Reject tiny trades.
  static const double minimumProfit = 5.0;

  static int maxAffordableQuantity({
    required City city,
    required MarketGood market,
    required double gold,
    required int maxQuantity,
  }) {
    int affordable = 0;

    for (
      int quantity = 1;
      quantity <= maxQuantity;
      quantity++
    ) {
      final cost =
          PricingService.transactionCost(
        city: city,
        market: market,
        quantity: quantity,
      );

      if (cost > gold) {
        break;
      }

      affordable = quantity;
    }

    return affordable;
  }

  static TradeMission? generateMission({
    required World world,
    required City origin,
    required NpcCaravan npc,
  }) {
    TradeMission? bestMission;

    double bestScore = 0;

    for (final market in origin.marketGoods) {
      final availableQuantity =
          market.quantity.floor();

      if (availableQuantity <= 0) {
        continue;
      }

      final remainingCargoKg =
          npc.caravan.cargoCapacityKg -
              npc.caravan.cargoWeightKg;

      final cargoLimit =
          (remainingCargoKg /
                  market.good.weight)
              .floor();

      if (cargoLimit <= 0) {
        continue;
      }

      final marketLimit = max(
        1,
        (availableQuantity *
                maxMarketShare)
            .floor(),
      );

      final affordableLimit =
          maxAffordableQuantity(
        city: origin,
        market: market,
        gold:
            npc.caravan.gold *
            maxGoldShare,
        maxQuantity: min(
          marketLimit,
          cargoLimit,
        ),
      );

      final quantity = min(
        affordableLimit,
        min(
          marketLimit,
          cargoLimit,
        ),
      );

      if (quantity <= 0) {
        continue;
      }

      final buyPrice =
          PricingService.calculatePrice(
        city: origin,
        market: market,
      );

      for (final destination
          in world.cities) {
        if (destination.id ==
            origin.id) {
          continue;
        }

        final sellMarket =
            destination.marketForGood(
          market.good,
        );

        final sellPrice =
            PricingService.calculatePrice(
          city: destination,
          market: sellMarket,
        );

        final cost =
            PricingService.transactionCost(
          city: origin,
          market: market,
          quantity: quantity,
        );

        final revenue =
            PricingService.transactionRevenue(
          city: destination,
          market: sellMarket,
          quantity: quantity,
        );

        final profit =
            revenue - cost;

        if (profit < minimumProfit) {
          continue;
        }

        final dx =
            destination.x - origin.x;

        final dy =
            destination.y - origin.y;

        final distance = sqrt(
          (dx * dx) + (dy * dy),
        );

        final travelDays =
            distance /
            (500 * npc.caravan.speed);

        final score =
            profit /
            max(
              1.0,
              travelDays,
            );

        if (score > bestScore) {
          bestScore = score;

          bestMission = TradeMission(
            good: market.good,
            origin: origin,
            destination: destination,
            quantity: quantity,
            expectedBuyPrice:
                buyPrice,
            expectedSellPrice:
                sellPrice,
            expectedProfit:
                profit,
          );
        }
      }
    }

    return bestMission;
  }

  static City randomRelocation({
    required World world,
    required City origin,
  }) {
    final destinations =
        world.cities
            .where(
              (city) =>
                  city.id != origin.id,
            )
            .toList();

    return destinations[
      Random().nextInt(
        destinations.length,
      )
    ];
  }
}