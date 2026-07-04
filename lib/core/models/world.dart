import '../../data/goods_data.dart';
import '../../data/industry_data.dart';
import 'city.dart';
import 'city_specialisation.dart';
import 'industry.dart';
import 'market_good.dart';
import 'npc_caravan.dart';

class World {
  final List<City> cities;
  final List<NpcCaravan> npcCaravans;

  World({
    required this.cities,
    required this.npcCaravans,
  });

  Map<String, dynamic> toJson() {
    return {
      'cities':
          cities
              .map((city) => city.toJson())
              .toList(),
      'npcCaravans':
          npcCaravans
              .map((npc) => npc.toJson())
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
                json: cityJson
                    as Map<String, dynamic>,
                citySpecialisationForName:
                    citySpecialisationForName,
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
              ),
            )
            .toList();

    world = World(
      cities: cities,
      npcCaravans: [],
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
    );
  }
}