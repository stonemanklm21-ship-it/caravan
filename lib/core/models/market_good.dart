import 'good.dart';

class MarketGood {
  final Good good;

  double supply;
  double demand;

  /// Quantity produced per day.
  double productionPerDay;

  /// Quantity consumed per day.
  double consumptionPerDay;

  MarketGood({
    required this.good,
    required this.supply,
    required this.demand,
    required this.productionPerDay,
    required this.consumptionPerDay,
  });

  double get scarcity {
    if (supply <= 0) {
      return double.infinity;
    }

    return demand / supply;
  }
}