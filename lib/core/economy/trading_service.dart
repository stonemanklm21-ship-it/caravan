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

  static bool buyFromNpc({
    required Caravan player,
    required Caravan npc,
    required CargoItem item,
    required int quantity,
    required double unitPrice,
  }) {
    if (item.quantity < quantity) {
      return false;
    }

    final cost = unitPrice * quantity;

    if (player.gold < cost) {
      return false;
    }

    final addedWeight =
        item.good.weight * quantity;

    if (player.cargoWeightKg +
            addedWeight >
        player.cargoCapacityKg) {
      return false;
    }

    player.gold -= cost;
    npc.gold += cost;

    final playerIndex =
        player.inventory.indexWhere(
      (cargo) =>
          cargo.good.id ==
          item.good.id,
    );

    if (playerIndex >= 0) {
      player
          .inventory[playerIndex]
          .quantity += quantity;
    } else {
      player.inventory.add(
        CargoItem(
          good: item.good,
          quantity:
              quantity.toDouble(),
        ),
      );
    }

    item.quantity -= quantity;

    if (item.quantity <= 0.0001) {
      npc.inventory.remove(item);
    }

    return true;
  }

  static bool sellToNpc({
    required Caravan player,
    required Caravan npc,
    required CargoItem item,
    required int quantity,
    required double unitPrice,
  }) {
    if (item.quantity < quantity) {
      return false;
    }

    final revenue =
        unitPrice * quantity;

    if (npc.gold < revenue) {
      return false;
    }

    npc.gold -= revenue;
    player.gold += revenue;

    item.quantity -= quantity;

    final npcIndex =
        npc.inventory.indexWhere(
      (cargo) =>
          cargo.good.id ==
          item.good.id,
    );

    if (npcIndex >= 0) {
      npc.inventory[npcIndex]
          .quantity += quantity;
    } else {
      npc.inventory.add(
        CargoItem(
          good: item.good,
          quantity:
              quantity.toDouble(),
        ),
      );
    }

    if (item.quantity <= 0.0001) {
      player.inventory.remove(item);
    }

    return true;
  }
}