import '../models/caravan.dart';
import '../models/cargo_item.dart';
import '../models/market_good.dart';
import 'pricing_service.dart';

class TradingService {
  static bool buy({
    required Caravan caravan,
    required MarketGood market,
    required int quantity,
  }) {
    final price = PricingService.calculatePrice(
      market: market,
    );

    final cost = price * quantity;

    if (caravan.gold < cost) {
      return false;
    }

    final addedWeight =
        market.good.weight * quantity;

    if (
      caravan.cargoWeightKg + addedWeight >
      caravan.cargoCapacityKg
    ) {
      return false;
    }

    if (market.supply < quantity) {
      return false;
    }

    caravan.gold -= cost;

    final existingIndex =
        caravan.inventory.indexWhere(
      (item) => item.good.name == market.good.name,
    );

    if (existingIndex >= 0) {
      caravan.inventory[existingIndex].quantity +=
          quantity.toDouble();
    } else {
      caravan.inventory.add(
        CargoItem(
          good: market.good,
          quantity: quantity.toDouble(),
        ),
      );
    }

    market.supply -= quantity;

    return true;
  }

  static bool sell({
    required Caravan caravan,
    required MarketGood market,
    required int quantity,
  }) {
    final existingIndex =
        caravan.inventory.indexWhere(
      (item) => item.good.name == market.good.name,
    );

    if (existingIndex < 0) {
      return false;
    }

    final item = caravan.inventory[existingIndex];

    if (item.quantity < quantity) {
      return false;
    }

    final price = PricingService.calculatePrice(
      market: market,
    );

    item.quantity -= quantity.toDouble();

    caravan.gold += price * quantity;

    if (item.quantity <= 0.0001) {
      caravan.inventory.removeAt(existingIndex);
    }

    market.supply += quantity;

    return true;
  }
}