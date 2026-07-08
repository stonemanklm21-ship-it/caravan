import '../models/city.dart';
import '../models/caravan.dart';
import '../models/cargo_item.dart';
import '../models/market_good.dart';
import 'pricing_service.dart';

class TradingService {
  static bool buy({
    required City city,
    required Caravan caravan,
    required MarketGood market,
    required int quantity,
  }) {
    final cost =
        PricingService.transactionCost(
      city: city,
      market: market,
      quantity: quantity,
    );

    if (caravan.gold < cost) {
      return false;
    }

    final addedWeight =
        market.good.weight * quantity;

    if (caravan.cargoWeightKg +
            addedWeight >
        caravan.cargoCapacityKg) {
      return false;
    }

    if (market.quantity < quantity) {
      return false;
    }

    caravan.gold -= cost;

    final existingIndex =
        caravan.inventory.indexWhere(
      (item) =>
          item.good.id ==
          market.good.id,
    );

    if (existingIndex >= 0) {
      caravan
          .inventory[existingIndex]
          .quantity += quantity;
    } else {
      caravan.inventory.add(
        CargoItem(
          good: market.good,
          quantity:
              quantity.toDouble(),
        ),
      );
    }

    market.quantity -= quantity;

    return true;
  }

  static bool sell({
    required City city,
    required Caravan caravan,
    required MarketGood market,
    required int quantity,
  }) {
    final existingIndex =
        caravan.inventory.indexWhere(
      (item) =>
          item.good.id ==
          market.good.id,
    );

    if (existingIndex < 0) {
      return false;
    }

    final item =
        caravan.inventory[
            existingIndex];

    if (item.quantity < quantity) {
      return false;
    }

    final revenue =
        PricingService
            .transactionRevenue(
      city: city,
      market: market,
      quantity: quantity,
    );

    item.quantity -= quantity;

    caravan.gold += revenue;

    if (item.quantity <= 0.0001) {
      caravan.inventory.removeAt(
        existingIndex,
      );
    }

    market.quantity += quantity;

    return true;
  }
}