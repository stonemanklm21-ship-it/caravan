import '../models/world.dart';

class EconomyService {
  static void advanceTime({
    required World world,
    required double hours,
  }) {
    final days = hours / 24;

    for (final city in world.cities) {
      for (final market in city.marketGoods) {
        market.supply +=
            market.productionPerDay * days;

        market.supply -=
            market.consumptionPerDay * days;

        market.demand +=
            market.consumptionPerDay *
            0.1 *
            days;

        if (market.supply < 1) {
          market.supply = 1;
        }

        if (market.demand < 1) {
          market.demand = 1;
        }
      }
    }
  }
}