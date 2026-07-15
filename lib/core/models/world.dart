import '../../data/animal_data.dart';
import '../../data/armour_data.dart';
import '../../data/goods_data.dart';
import '../../data/helmet_data.dart';
import '../../data/industry_data.dart';
import '../../data/vehicle_data.dart';
import '../../data/weapon_data.dart';
import '../../data/region_data.dart';

import 'animal.dart';
import 'city.dart';
import 'industry.dart';
import 'market_good.dart';
import 'npc_caravan.dart';
import 'recruit.dart';
import 'vehicle.dart';

class World {
  final List<City> cities;

  final List<NpcCaravan> npcCaravans;

  final List<NpcCaravan> caravansToRemove;

  World({
    required this.cities,
    required this.npcCaravans,
    List<NpcCaravan>? caravansToRemove,
  }) : caravansToRemove =
           caravansToRemove ?? [];

  Map<String, dynamic> toJson() {
    return {
      'cities': cities
          .map(
            (city) => city.toJson(),
          )
          .toList(),
      'npcCaravans': npcCaravans
          .map(
            (npc) => npc.toJson(),
          )
          .toList(),
    };
  }

  factory World.fromJson(
    Map<String, dynamic> json,
  ) {
    late World world;

    final cities =
        (json['cities'] as List)
            .map(
              (cityJson) => City.fromJson(
                json:
                    cityJson
                        as Map<String, dynamic>,
                regionForId:
                    regionForId,
                industryFromJson:
                    (industryJson) =>
                        Industry.fromJson(
                  json: industryJson,
                  industryTypeForId:
                      industryTypeForId,
                  goodForId:
                      goodForId,
                ),
                marketGoodFromJson:
                    (marketJson) =>
                        MarketGood.fromJson(
                  json: marketJson,
                  goodForId:
                      goodForId,
                ),
                goodForId:
                    goodForId,
                recruitFromJson:
                    (recruitJson) =>
                        Recruit.fromJson(
                  json: recruitJson,
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
                weaponForId:
                    weaponForId,
                armourForId:
                    armourForId,
                helmetForId:
                    helmetForId,
              ),
            )
            .toList();

    world = World(
      cities: cities,
      npcCaravans: [],
      caravansToRemove: [],
    );

    final npcCaravans =
        (json['npcCaravans'] as List)
            .map(
              (npcJson) =>
                  NpcCaravan.fromJson(
                npcJson
                    as Map<String, dynamic>,
                world,
              ),
            )
            .toList();

    return World(
      cities: cities,
      npcCaravans: npcCaravans,
      caravansToRemove: [],
    );
  }
}