import '../models/world.dart';
import 'demand_service.dart';

class PopulationService {
  static void advanceTime({
    required World world,
    required double hours,
  }) {
    final days = hours / 24;

    for (final city in world.cities) {
      for (final market in city.marketGoods) {
        final demandPerDay =
            DemandService.populationDemandPerDay(
          city: city,
          good: market.good,
        );

        market.quantity -=
            demandPerDay * days;

        if (market.quantity < 0) {
          market.quantity = 0;
        }
      }
    }
  }
}