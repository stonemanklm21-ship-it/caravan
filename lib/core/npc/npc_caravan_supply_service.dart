import '../../data/goods_data.dart';
import '../economy/pricing_service.dart';
import '../economy/trading_service.dart';
import '../models/city.dart';
import '../models/npc_caravan.dart';

class NpcCaravanSupplyService {
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

    _buyFoodCalories(
      npc: npc,
      city: city,
      targetCalories:
          npc.caravan.calorieRequirementPerDay *
          targetDays,
    );
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

  static void _buyFoodCalories({
    required NpcCaravan npc,
    required City city,
    required double targetCalories,
  }) {
    final currentCalories =
        npc.caravan.inventory.fold<double>(
      0,
      (total, item) =>
          total +
          item.quantity *
              item.good.caloriesPerUnit,
    );

    var caloriesNeeded =
        targetCalories -
        currentCalories;

    if (caloriesNeeded <= 0) {
      return;
    }

    final foodMarkets =
        city.marketGoods
            .where(
              (market) =>
                  market.good
                          .caloriesPerUnit >
                      0 &&
                  market.good.id !=
                      water.id &&
                  market.good.id !=
                      forage.id,
            )
            .toList();

    foodMarkets.sort(
      (a, b) {
        final aCostPerCalorie =
            PricingService.calculatePrice(
              city: city,
              market: a,
            ) /
            a.good.caloriesPerUnit;

        final bCostPerCalorie =
            PricingService.calculatePrice(
              city: city,
              market: b,
            ) /
            b.good.caloriesPerUnit;

        return aCostPerCalorie
            .compareTo(
          bCostPerCalorie,
        );
      },
    );

    for (final market
        in foodMarkets) {
      if (caloriesNeeded <= 0) {
        break;
      }

      final quantity =
          (caloriesNeeded /
                  market.good
                      .caloriesPerUnit)
              .ceil();

      TradingService.buy(
        city: city,
        caravan: npc.caravan,
        market: market,
        quantity: quantity,
      );

      caloriesNeeded -=
          quantity *
              market.good
                  .caloriesPerUnit;
    }
  }
}