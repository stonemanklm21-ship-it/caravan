import '../../data/animal_data.dart';
import '../../data/vehicle_data.dart';

import '../economy/market_ledger.dart';
import '../travel/active_journey.dart';

import 'animal.dart';
import 'caravan.dart';
import 'caravan_faction.dart';
import 'city.dart';
import 'region.dart';
import 'trade_mission.dart';
import 'vehicle.dart';
import 'world.dart';

enum CaravanState {
  idle,
  travelling,
  selling,
}

class NpcCaravan {
  double worldX;

  double worldY;

  City? currentCity;

  Region? homeRegion;

  double idleHoursRemaining;

  Caravan caravan;

  CaravanFaction faction;

  ActiveJourney? activeJourney;

  MarketLedger ledger;

  String lastDecision;

  TradeMission? activeMission;
  NpcCaravan? followTarget;

  CaravanState state;

  NpcCaravan({
    required this.worldX,
    required this.worldY,
    required this.currentCity,
    required this.caravan,
    required this.faction,
    required this.ledger,
    this.homeRegion,
    this.idleHoursRemaining = 0,
    this.activeJourney,
    this.lastDecision = 'None',
    this.activeMission,
    this.followTarget,
    this.state = CaravanState.idle,
  });

  Map<String, dynamic> toJson() {
    return {
      'worldX': worldX,
      'worldY': worldY,
      'currentCity': currentCity?.id,
      'homeRegion': homeRegion?.id,
      'caravan': caravan.toJson(),
      'faction': faction.name,
      'ledger': ledger.toJson(),
      'activeJourney': activeJourney?.toJson(),
      'lastDecision': lastDecision,
      'state': state.name,

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

    Region? homeRegion;

    final homeRegionId =
        json['homeRegion'] as String?;

    if (homeRegionId != null) {
      homeRegion = world.cities
          .firstWhere(
            (city) =>
                city.region.id ==
                homeRegionId,
          )
          .region;
    }

    return NpcCaravan(
      worldX:
          (json['worldX'] as num)
              .toDouble(),
      worldY:
          (json['worldY'] as num)
              .toDouble(),
      currentCity: currentCity,
      homeRegion: homeRegion,
      caravan: Caravan.fromJson(
        json:
            json['caravan']
                as Map<String, dynamic>,
        animalFromJson:
            (animalJson) => Animal.fromJson(
          json: animalJson,
          animalTypeForId:
              animalTypeForId,
        ),
        vehicleFromJson:
            (vehicleJson) => Vehicle.fromJson(
          json: vehicleJson,
          vehicleTypeForId:
              vehicleTypeForId,
          animalFromJson:
              (animalJson) => Animal.fromJson(
            json: animalJson,
            animalTypeForId:
                animalTypeForId,
          ),
        ),
      ),
      faction:
          json['faction'] == null
              ? CaravanFaction.merchant
              : CaravanFaction.values
                    .firstWhere(
                    (faction) =>
                        faction.name ==
                        json['faction'],
                  ),
      ledger: MarketLedger.fromJson(
        json['ledger']
            as Map<String, dynamic>,
      ),
      activeJourney:
          json['activeJourney'] == null
              ? null
              : ActiveJourney.fromJson(
                  json['activeJourney']
                      as Map<String, dynamic>,
                  world,
                ),
      lastDecision:
          json['lastDecision']
                  as String? ??
              'None',
      state: CaravanState.values.firstWhere(
        (state) =>
            state.name ==
            (json['state']
                    as String? ??
                'idle'),
        orElse: () =>
            CaravanState.idle,
      ),

      activeMission: null,
    );
  }
}