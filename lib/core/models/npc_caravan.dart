import '../../data/animal_data.dart';
import '../../data/vehicle_data.dart';
import '../../data/bandit_faction_data.dart';

import '../bandits/bandit_target.dart';
import '../economy/market_ledger.dart';
import '../travel/active_journey.dart';
import '../npc/npc_travel_service.dart';
import 'bandit_faction.dart';

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
  roaming,
  pursuing,
  recovering
}

class NpcCaravan
    implements BanditTarget {
  double worldX;

  double worldY;

  City? currentCity;

  Region? homeRegion;

  double idleHoursRemaining;

  Caravan caravan;

  CaravanFaction faction;

  BanditFaction? banditFaction;

  ActiveJourney? activeJourney;

  MarketLedger ledger;

  String lastDecision;

  TradeMission? activeMission;

  BanditTarget? followTarget;

  CaravanState state;

  double surrenderProtectionHours;

  NpcCaravan({
    required this.worldX,
    required this.worldY,
    required this.currentCity,
    required this.caravan,
    required this.faction,
    this.banditFaction,
    required this.ledger,
    this.homeRegion,
    this.idleHoursRemaining = 0,
    this.activeJourney,
    this.lastDecision = 'None',
    this.activeMission,
    this.followTarget,
    this.state = CaravanState.idle,
    this.surrenderProtectionHours = 0,
  });

  @override
  double get x =>
      NpcTravelService.currentX(
        this,
      );

  @override
  double get y =>
      NpcTravelService.currentY(
        this,
      );

  @override
  double get smoothX => x;

  @override
  double get smoothY => y;

  @override
  bool get isInSafeZone =>
      currentCity != null;

  Map<String, dynamic> toJson() {
    return {
      'worldX': worldX,
      'worldY': worldY,
      'currentCity': currentCity?.id,
      'homeRegion': homeRegion?.id,
      'caravan': caravan.toJson(),
      'banditFaction': banditFaction?.id,
      'faction': faction.name,
      'ledger': ledger.toJson(),
      'activeJourney': activeJourney?.toJson(),
      'lastDecision': lastDecision,
      'state': state.name,
      'surrenderProtectionHours':
          surrenderProtectionHours,
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
      faction:
          json['faction'] == null
              ? CaravanFaction.merchant
              : CaravanFaction.values
                    .firstWhere(
                  (faction) =>
                      faction.name ==
                      json['faction'],
                ),
      banditFaction:
          json['banditFaction'] ==
                  null
              ? null
              : banditFactionForId(
                  json['banditFaction']
                      as String,
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
      surrenderProtectionHours:
          (json[
                      'surrenderProtectionHours']
                  as num?)
              ?.toDouble() ??
          0,
    );
  }
}