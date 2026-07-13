import '../../data/animal_data.dart';
import '../../data/vehicle_data.dart';

import 'world.dart';
import '../travel/active_journey.dart';
import 'animal.dart';
import 'caravan.dart';
import 'city.dart';
import '../economy/market_ledger.dart';
import 'vehicle.dart';
import 'npc_caravan.dart';

class PlayerState {
  /// Total world time since the start of the game.
  double worldTimeHours;

  /// Current caravan position on the world map.
  double worldX;
  double worldY;

  /// Current city occupied by the player.
  City? currentCity;

  /// Cities the player has discovered.
  /// Stores city IDs, not names.
  final Set<String> discoveredCities;

  /// Player caravan.
  Caravan caravan;

  /// Player's knowledge of market prices.
  MarketLedger ledger;

  /// Null when stationary.
  /// Non-null when travelling.
  ActiveJourney? activeJourney;

  /// Temporary encounter currently being handled.
  /// Not saved.
  NpcCaravan? encounteredNpc;
 final Set<NpcCaravan> ignoredNpcs = {};
  
  PlayerState({
    required this.worldTimeHours,
    required this.worldX,
    required this.worldY,
    required this.currentCity,
    required this.discoveredCities,
    required this.caravan,
    required this.ledger,
    this.activeJourney,
    this.encounteredNpc,
  });

  int get day => (worldTimeHours ~/ 24) + 1;

  int get hour => worldTimeHours.floor() % 24;

  bool get isTravelling =>
      activeJourney != null;

  Map<String, dynamic> toJson() {
    return {
      'saveVersion': 1,
      'worldTimeHours': worldTimeHours,
      'worldX': worldX,
      'worldY': worldY,
      'currentCity': currentCity?.id,
      'discoveredCities':
          discoveredCities.toList(),
      'caravan': caravan.toJson(),
      'ledger': ledger.toJson(),
      'activeJourney':
          activeJourney?.toJson(),
    };
  }

  factory PlayerState.fromJson(
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

    return PlayerState(
      worldTimeHours:
          (json['worldTimeHours']
                  as num)
              .toDouble(),
      worldX:
          (json['worldX'] as num)
              .toDouble(),
      worldY:
          (json['worldY'] as num)
              .toDouble(),
      currentCity: currentCity,
      discoveredCities:
          Set<String>.from(
        json['discoveredCities']
            as List,
      ),
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