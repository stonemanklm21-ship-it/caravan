import '../models/world.dart';
import 'industry_service.dart';
import 'population_service.dart';

class EconomyService {
  static void advanceTime({
    required World world,
    required double hours,
  }) {
    PopulationService.advanceTime(
      world: world,
      hours: hours,
    );

    IndustryService.advanceTime(
      world: world,
      hours: hours,
    );

    for (final city in world.cities) {
      for (final market in city.marketGoods) {
        if (market.quantity < 0) {
          market.quantity = 0;
        }
      }
    }
  }
}