import 'dart:math';

import '../economy/pricing_service.dart';
import '../models/city.dart';
import '../models/market_good.dart';
import '../models/npc_caravan.dart';
import '../models/trade_mission.dart';
import '../models/world.dart';

class NpcTradingService {
  static const double maxMarketShare = 0.95;
  static const double maxGoldShare = 0.75;
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

  static List<TradeMission>
      generateMissionsForDestination({
    required City origin,
    required City destination,
    required NpcCaravan npc,
    required double availableGold,
    required double availableCargoKg,
  }) {
    final missions = <TradeMission>[];

    for (final market in origin.marketGoods) {
      final availableQuantity =
          market.quantity.floor();

      if (availableQuantity <= 0) {
        continue;
      }

      final cargoLimit =
          (availableCargoKg /
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
            availableGold *
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

      final sellMarket =
          destination.marketForGood(
        market.good,
      );

      final buyPrice =
          PricingService.calculatePrice(
        city: origin,
        market: market,
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

      missions.add(
        TradeMission(
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
        ),
      );
    }

    missions.sort(
      (a, b) => b.expectedProfit
          .compareTo(
        a.expectedProfit,
      ),
    );

    return missions;
  }

  static TradeMission? generateMission({
    required World world,
    required City origin,
    required NpcCaravan npc,
    required double availableGold,
    required double availableCargoKg,
  }) {
    TradeMission? bestMission;

    double bestScore = 0;

    for (final destination
        in world.cities) {
      if (destination.id ==
          origin.id) {
        continue;
      }

      final missions =
          generateMissionsForDestination(
        origin: origin,
        destination: destination,
        npc: npc,
        availableGold:
            availableGold,
        availableCargoKg:
            availableCargoKg,
      );

      if (missions.isEmpty) {
        continue;
      }

      final mission =
          missions.first;

      final dx =
          destination.x -
          origin.x;

      final dy =
          destination.y -
          origin.y;

      final distance =
          sqrt(
            (dx * dx) +
                (dy * dy),
          );

      final travelDays =
          distance /
          (500 *
              npc.caravan.speed);

      final score =
          mission.expectedProfit /
          max(
            1.0,
            travelDays,
          );

      if (score > bestScore) {
        bestScore = score;
        bestMission = mission;
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