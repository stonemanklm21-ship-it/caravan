import '../economy/animal_market_service.dart';
import '../economy/equipment_market_service.dart';
import '../economy/vehicle_market_service.dart';

import 'animal.dart';
import 'armour.dart';
import 'good.dart';
import 'helmet.dart';
import 'industry.dart';
import 'market_good.dart';
import 'recruit.dart';
import 'vehicle.dart';
import 'weapon.dart';
import 'region.dart';

class City {
  final String id;

  final String name;

  final Region region;

  final double x;

  final double y;

  final int population;

  final List<Industry> industries;

  final List<MarketGood> marketGoods;

  final List<Good> shopGoods;

  final AnimalMarketTier?
      animalMarketTier;

  final VehicleMarketTier?
      vehicleMarketTier;

  final EquipmentMarketTier?
      equipmentMarketTier;

  final bool hasVet;

  final bool hasCartwright;

  final bool hasDoctor;

  List<Recruit> recruits;

  List<Animal> animalMarketStock;

  List<Vehicle> vehicleMarketStock;

  List<Weapon> weaponMarketStock;

  List<Armour> armourMarketStock;

  List<Helmet> helmetMarketStock;

  int lastRecruitRefreshHour;

  int lastAnimalMarketRefreshHour;

  int lastVehicleMarketRefreshHour;

  int lastEquipmentMarketRefreshHour;

  City({
    required this.id,
    required this.name,
    required this.region,
    required this.x,
    required this.y,
    required this.population,
    required this.industries,
    required this.marketGoods,
    required this.shopGoods,
    this.animalMarketTier,
    this.vehicleMarketTier,
    this.equipmentMarketTier,
    this.hasVet = false,
    this.hasCartwright = false,
    this.hasDoctor = false,
    this.recruits = const [],
    this.animalMarketStock =
        const [],
    this.vehicleMarketStock =
        const [],
    this.weaponMarketStock =
        const [],
    this.armourMarketStock =
        const [],
    this.helmetMarketStock =
        const [],
    this.lastRecruitRefreshHour = 0,
    this.lastAnimalMarketRefreshHour =
        0,
    this.lastVehicleMarketRefreshHour =
        0,
    this.lastEquipmentMarketRefreshHour =
        0,
  });

  MarketGood marketForGood(
    Good good,
  ) {
    return marketGoods.firstWhere(
      (market) =>
          market.good.id == good.id,
    );
  }

  MarketGood marketForGoodId(
    String goodId,
  ) {
    return marketGoods.firstWhere(
      (market) =>
          market.good.id == goodId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'region': region.id,
      'x': x,
      'y': y,
      'population': population,
      'industries': industries
          .map(
            (industry) =>
                industry.toJson(),
          )
          .toList(),
      'marketGoods': marketGoods
          .map(
            (market) =>
                market.toJson(),
          )
          .toList(),
      'shopGoods': shopGoods
          .map(
            (good) => good.id,
          )
          .toList(),
      'animalMarketTier':
          animalMarketTier?.name,
      'vehicleMarketTier':
          vehicleMarketTier?.name,
      'equipmentMarketTier':
          equipmentMarketTier?.name,
      'hasVet': hasVet,
      'hasCartwright':
          hasCartwright,
      'hasDoctor':
          hasDoctor,
      'recruits': recruits
          .map(
            (recruit) =>
                recruit.toJson(),
          )
          .toList(),
      'animalMarketStock':
          animalMarketStock
              .map(
                (animal) =>
                    animal.toJson(),
              )
              .toList(),
      'vehicleMarketStock':
          vehicleMarketStock
              .map(
                (vehicle) =>
                    vehicle.toJson(),
              )
              .toList(),
      'weaponMarketStock':
          weaponMarketStock
              .map(
                (weapon) =>
                    weapon.id,
              )
              .toList(),
      'armourMarketStock':
          armourMarketStock
              .map(
                (armour) =>
                    armour.id,
              )
              .toList(),
      'helmetMarketStock':
          helmetMarketStock
              .map(
                (helmet) =>
                    helmet.id,
              )
              .toList(),
      'lastRecruitRefreshHour':
          lastRecruitRefreshHour,
      'lastAnimalMarketRefreshHour':
          lastAnimalMarketRefreshHour,
      'lastVehicleMarketRefreshHour':
          lastVehicleMarketRefreshHour,
      'lastEquipmentMarketRefreshHour':
          lastEquipmentMarketRefreshHour,
    };
  }

  factory City.fromJson({
    required Map<String, dynamic>
        json,

    required Region Function(
  String id,
)
regionForId,
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
    required Recruit Function(
      Map<String, dynamic> json,
    )
    recruitFromJson,
    required Animal Function(
      Map<String, dynamic> json,
    )
    animalFromJson,
    required Vehicle Function(
      Map<String, dynamic> json,
    )
    vehicleFromJson,
    required Weapon Function(
      String id,
    )
    weaponForId,
    required Armour Function(
      String id,
    )
    armourForId,
    required Helmet Function(
      String id,
    )
    helmetForId,
  }) {
    return City(
      id: json['id'] as String,
      name: json['name'] as String,
      region: regionForId(
  json['region'] as String,
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
      animalMarketTier:
          json['animalMarketTier'] ==
                  null
              ? null
              : AnimalMarketTier
                    .values
                    .firstWhere(
                      (tier) =>
                          tier.name ==
                          json['animalMarketTier'],
                    ),
      vehicleMarketTier:
          json['vehicleMarketTier'] ==
                  null
              ? null
              : VehicleMarketTier
                    .values
                    .firstWhere(
                      (tier) =>
                          tier.name ==
                          json['vehicleMarketTier'],
                    ),
      equipmentMarketTier:
          json['equipmentMarketTier'] ==
                  null
              ? null
              : EquipmentMarketTier
                    .values
                    .firstWhere(
                      (tier) =>
                          tier.name ==
                          json['equipmentMarketTier'],
                    ),
      hasVet:
          json['hasVet']
                  as bool? ??
              false,
      hasCartwright:
          json['hasCartwright']
                  as bool? ??
              false,
      hasDoctor:
          json['hasDoctor']
                  as bool? ??
              false,
      recruits:
          (json['recruits']
                      as List?)
                  ?.map(
                    (recruitJson) =>
                        recruitFromJson(
                      recruitJson
                          as Map<String,
                              dynamic>,
                    ),
                  )
                  .toList() ??
              [],
      animalMarketStock:
          (json['animalMarketStock']
                      as List?)
                  ?.map(
                    (animalJson) =>
                        animalFromJson(
                      animalJson
                          as Map<String,
                              dynamic>,
                    ),
                  )
                  .toList() ??
              [],
      vehicleMarketStock:
          (json['vehicleMarketStock']
                      as List?)
                  ?.map(
                    (vehicleJson) =>
                        vehicleFromJson(
                      vehicleJson
                          as Map<String,
                              dynamic>,
                    ),
                  )
                  .toList() ??
              [],
      weaponMarketStock:
          (json['weaponMarketStock']
                      as List?)
                  ?.map(
                    (id) => weaponForId(
                      id as String,
                    ),
                  )
                  .toList() ??
              [],
      armourMarketStock:
          (json['armourMarketStock']
                      as List?)
                  ?.map(
                    (id) => armourForId(
                      id as String,
                    ),
                  )
                  .toList() ??
              [],
      helmetMarketStock:
          (json['helmetMarketStock']
                      as List?)
                  ?.map(
                    (id) => helmetForId(
                      id as String,
                    ),
                  )
                  .toList() ??
              [],
      lastRecruitRefreshHour:
          json['lastRecruitRefreshHour']
                  as int? ??
              0,
      lastAnimalMarketRefreshHour:
          json['lastAnimalMarketRefreshHour']
                  as int? ??
              0,
      lastVehicleMarketRefreshHour:
          json['lastVehicleMarketRefreshHour']
                  as int? ??
              0,
      lastEquipmentMarketRefreshHour:
          json['lastEquipmentMarketRefreshHour']
                  as int? ??
              0,
    );
  }
}