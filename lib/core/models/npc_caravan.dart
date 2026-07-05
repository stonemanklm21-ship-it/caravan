import '../../data/animal_data.dart';
import '../../data/vehicle_data.dart';

import '../economy/market_ledger.dart';
import '../travel/active_journey.dart';
import 'animal.dart';
import 'caravan.dart';
import 'city.dart';
import 'vehicle.dart';
import 'world.dart';

class NpcCaravan {
  double worldX;
  double worldY;

  City? currentCity;

  Caravan caravan;

  ActiveJourney? activeJourney;

  MarketLedger ledger;

  NpcCaravan({
    required this.worldX,
    required this.worldY,
    required this.currentCity,
    required this.caravan,
    required this.ledger,
    this.activeJourney,
  });

  Map<String, dynamic> toJson() {
    return {
      'worldX': worldX,
      'worldY': worldY,
      'currentCity': currentCity?.id,
      'caravan': caravan.toJson(),
      'ledger': ledger.toJson(),
      'activeJourney':
          activeJourney?.toJson(),
    };
  }

  factory NpcCaravan.fromJson(
    Map<String, dynamic> json,
    World world,
  ) {
    final cityId =
        json['currentCity'] as String?;

    City? currentCity;

    if (cityId != null) {
      currentCity = world.cities.firstWhere(
        (city) => city.id == cityId,
      );
    }

    return NpcCaravan(
      worldX:
          (json['worldX'] as num)
              .toDouble(),
      worldY:
          (json['worldY'] as num)
              .toDouble(),
      currentCity: currentCity,
      caravan: Caravan.fromJson(
        json: json['caravan']
            as Map<String, dynamic>,
        animalFromJson:
            (animalJson) =>
                Animal.fromJson(
          json: animalJson,
          animalTypeForId:
              animalTypeForId,
        ),
        vehicleFromJson:
            (vehicleJson) =>
                Vehicle.fromJson(
          json: vehicleJson,
          vehicleTypeForId:
              vehicleTypeForId,
          animalFromJson:
              (animalJson) =>
                  Animal.fromJson(
            json: animalJson,
            animalTypeForId:
                animalTypeForId,
          ),
        ),
      ),
      ledger:
          MarketLedger.fromJson(
        json['ledger']
            as Map<String, dynamic>,
      ),
      activeJourney:
          json['activeJourney'] ==
                  null
              ? null
              : ActiveJourney.fromJson(
                  json['activeJourney']
                      as Map<String,
                          dynamic>,
                  world,
                ),
    );
  }
}