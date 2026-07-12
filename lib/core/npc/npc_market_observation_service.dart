import '../economy/market_observation.dart';
import '../economy/pricing_service.dart';
import '../models/npc_caravan.dart';

class NpcMarketObservationService {
  static void observeCurrentCity({
    required NpcCaravan npc,
  }) {
    final city = npc.currentCity;

    if (city == null) {
      return;
    }

    for (final market in city.marketGoods) {
      npc.ledger.observations.removeWhere(
        (observation) =>
            observation.cityId == city.id &&
            observation.goodId == market.good.id,
      );

      npc.ledger.observations.add(
        MarketObservation(
          cityId: city.id,
          goodId: market.good.id,
          price: PricingService.calculatePrice(
            city: city,
            market: market,
          ),
          day: 0,
          hour: 0,
        ),
      );
    }
  }
}