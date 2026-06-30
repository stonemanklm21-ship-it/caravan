import 'city_specialisation.dart';
import 'good.dart';
import 'market_good.dart';

class City {
  final String name;

  final CitySpecialisation specialisation;

  final double x;
  final double y;

  final List<MarketGood> marketGoods;

  City({
    required this.name,
    required this.specialisation,
    required this.x,
    required this.y,
    required this.marketGoods,
  });

  MarketGood marketForGood(Good good) {
    return marketGoods.firstWhere(
      (market) => market.good.name == good.name,
    );
  }

  MarketGood marketForGoodName(String goodName) {
    return marketGoods.firstWhere(
      (market) => market.good.name == goodName,
    );
  }
}