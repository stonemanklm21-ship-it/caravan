import '../models/market_good.dart';

class PricingService {
  static double calculatePrice({
    required MarketGood market,
  }) {
    final supply = market.supply.clamp(
      1.0,
      double.infinity,
    );

    return market.good.basePrice *
        (market.demand / supply);
  }
}