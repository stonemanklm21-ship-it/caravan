import '../models/market_good.dart';

class PricingService {
  static const double targetQuantity =
      100;

  static double calculatePrice({
    required MarketGood market,
  }) {
    final quantity =
        market.quantity.clamp(
      0.0,
      targetQuantity,
    );

    final scarcity =
        1 - (quantity / targetQuantity);

    return market.good.priceFloor +
        ((market.good.priceCeiling -
                market.good.priceFloor) *
            scarcity);
  }

  static double transactionCost({
    required MarketGood market,
    required int quantity,
  }) {
    final originalQuantity =
        market.quantity;

    final startPrice =
        calculatePrice(
      market: market,
    );

    final endQuantity =
        (originalQuantity - quantity)
            .clamp(
      0.0,
      double.infinity,
    );

    market.quantity =
        endQuantity;

    final endPrice =
        calculatePrice(
      market: market,
    );

    market.quantity =
        originalQuantity;

    return ((startPrice + endPrice) /
            2) *
        quantity;
  }

  static double transactionRevenue({
    required MarketGood market,
    required int quantity,
  }) {
    final originalQuantity =
        market.quantity;

    final startPrice =
        calculatePrice(
      market: market,
    );

    market.quantity =
        originalQuantity + quantity;

    final endPrice =
        calculatePrice(
      market: market,
    );

    market.quantity =
        originalQuantity;

    return ((startPrice + endPrice) /
            2) *
        quantity;
  }
}