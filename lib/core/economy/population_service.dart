import '../../data/goods_data.dart';
import '../models/world.dart';

class PopulationService {
  static void advanceTime({
    required World world,
    required double hours,
  }) {
    final days = hours / 24;

    for (final city in world.cities) {
      final breadMarket =
          city.marketForGood(
        bread,
      );

      final waterMarket =
          city.marketForGood(
        water,
      );

      final toolsMarket =
          city.marketForGood(
        tools,
      );

      final woodMarket =
          city.marketForGood(
        wood,
      );

      final chairMarket =
          city.marketForGood(
        chair,
      );

      breadMarket.quantity -=
          city.population *
          0.01 *
          days;

      waterMarket.quantity -=
          city.population *
          0.01 *
          days;

      toolsMarket.quantity -=
          city.population *
          0.002 *
          days;

      woodMarket.quantity -=
          city.population *
          0.002 *
          days;

      chairMarket.quantity -=
          city.population *
          0.002 *
          days;

      if (breadMarket.quantity < 0) {
        breadMarket.quantity = 0;
      }

      if (waterMarket.quantity < 0) {
        waterMarket.quantity = 0;
      }

      if (toolsMarket.quantity < 0) {
        toolsMarket.quantity = 0;
      }

      if (woodMarket.quantity < 0) {
        woodMarket.quantity = 0;
      }

      if (chairMarket.quantity < 0) {
        chairMarket.quantity = 0;
      }
    }
  }
}