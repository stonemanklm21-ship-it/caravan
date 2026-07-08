import '../models/city.dart';
import '../models/market_good.dart';
import 'demand_service.dart';

class PricingService {
  static const double targetDaysSupply =
      7;

  static double calculatePrice({
    required City city,
    required MarketGood market,
  }) {
    final demandPerDay =
        DemandService.totalDemandPerDay(
      city: city,
      good: market.good,
    );

    if (demandPerDay <= 0) {
      return market.good.priceFloor;
    }

    final targetQuantity =
        demandPerDay *
        targetDaysSupply;

    final scarcity =
        (1 -
                (market.quantity /
                    targetQuantity))
            .clamp(0.0, 1.0);

    return market.good.priceFloor +
        ((market.good.priceCeiling -
                market.good.priceFloor) *
            scarcity);
  }

  static double transactionCost({
    required City city,
    required MarketGood market,
    required int quantity,
  }) {
    final originalQuantity =
        market.quantity;

    final startPrice =
        calculatePrice(
      city: city,
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
      city: city,
      market: market,
    );

    market.quantity =
        originalQuantity;

    return ((startPrice + endPrice) / 2) *
        quantity;
  }

  static double transactionRevenue({
    required City city,
    required MarketGood market,
    required int quantity,
  }) {
    final originalQuantity =
        market.quantity;

    final startPrice =
        calculatePrice(
      city: city,
      market: market,
    );

    market.quantity =
        originalQuantity + quantity;

    final endPrice =
        calculatePrice(
      city: city,
      market: market,
    );

    market.quantity =
        originalQuantity;

    return ((startPrice + endPrice) / 2) *
        quantity;
  }
}