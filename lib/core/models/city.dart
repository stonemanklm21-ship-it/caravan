import 'city_specialisation.dart';
import 'good.dart';
import 'industry.dart';
import 'market_good.dart';

class City {
  final String id;
  final String name;

  final CitySpecialisation specialisation;

  final double x;
  final double y;

  final int population;

  final List<Industry> industries;

  final List<MarketGood> marketGoods;

  final List<Good> shopGoods;

  City({
    required this.id,
    required this.name,
    required this.specialisation,
    required this.x,
    required this.y,
    required this.population,
    required this.industries,
    required this.marketGoods,
    required this.shopGoods,
  });

  MarketGood marketForGood(Good good) {
    return marketGoods.firstWhere(
      (market) => market.good.id == good.id,
    );
  }

  MarketGood marketForGoodId(
    String goodId,
  ) {
    return marketGoods.firstWhere(
      (market) => market.good.id == goodId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialisation': specialisation.name,
      'x': x,
      'y': y,
      'population': population,
      'industries': industries
          .map(
            (industry) => industry.toJson(),
          )
          .toList(),
      'marketGoods': marketGoods
          .map(
            (market) => market.toJson(),
          )
          .toList(),
      'shopGoods': shopGoods
          .map(
            (good) => good.id,
          )
          .toList(),
    };
  }

  factory City.fromJson({
    required Map<String, dynamic> json,
    required CitySpecialisation Function(
      String name,
    )
    citySpecialisationForName,
    required Industry Function(
      Map<String, dynamic> json,
    )
    industryFromJson,
    required MarketGood Function(
      Map<String, dynamic> json,
    )
    marketGoodFromJson,
    required Good Function(
      String id,
    )
    goodForId,
  }) {
    return City(
      id: json['id'] as String,
      name: json['name'] as String,
      specialisation:
          citySpecialisationForName(
        json['specialisation']
            as String,
      ),
      x:
          (json['x'] as num)
              .toDouble(),
      y:
          (json['y'] as num)
              .toDouble(),
      population:
          json['population']
              as int,
      industries:
          (json['industries']
                  as List)
              .map(
                (industryJson) =>
                    industryFromJson(
                  industryJson
                      as Map<String,
                          dynamic>,
                ),
              )
              .toList(),
      marketGoods:
          (json['marketGoods']
                  as List)
              .map(
                (marketJson) =>
                    marketGoodFromJson(
                  marketJson
                      as Map<String,
                          dynamic>,
                ),
              )
              .toList(),
      shopGoods:
          (json['shopGoods']
                  as List)
              .map(
                (id) => goodForId(
                  id as String,
                ),
              )
              .toList(),
    );
  }
}