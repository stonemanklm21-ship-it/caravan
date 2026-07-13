import '../caravan/caravan_service.dart';
import 'animal.dart';
import 'cargo_item.dart';
import 'cargo_manifest_entry.dart';
import 'character.dart';
import 'vehicle.dart';
import 'weapon.dart';
import 'armour.dart';
import 'helmet.dart';
import '../../data/weapon_data.dart';
import '../../data/armour_data.dart';
import '../../data/helmet_data.dart';

class Caravan {
  Character leader;

  List<Character> companions;

  double gold;

  List<CargoItem> inventory;

  List<Weapon> weapons;

  List<Armour> armours;

  List<Helmet> helmets;

  List<Animal> animals;

  List<Vehicle> vehicles;

  final List<CargoManifestEntry> manifest;

  Caravan({
    required this.leader,
    required this.companions,
    required this.gold,
    required this.inventory,
    required this.weapons,
    required this.armours,
    required this.helmets,
    required this.animals,
    required this.vehicles,
    required this.manifest,
  });

  double get cargoCapacityKg =>
      CaravanService.cargoCapacityKg(
        this,
      );

  double get cargoWeightKg {
    return inventory.fold<double>(
      0,
      (total, item) =>
          total +
          (item.good.weight *
              item.quantity),
    );
  }

  double get availableCapacityKg {
    return cargoCapacityKg -
        cargoWeightKg;
  }

double get speed {
  double slowest =
      leader.effectiveSpeed;

  for (final companion
      in companions) {
    if (companion.alive &&
        companion.effectiveSpeed <
            slowest) {
      slowest =
          companion.effectiveSpeed;
    }
  }

  for (final animal
      in animals) {
    if (animal.alive &&
        animal.type.speed <
            slowest) {
      slowest =
          animal.type.speed;
    }
  }

  return slowest;
}

  int get doctorSkill {
    int total = leader.doctorSkill;

    for (final companion
        in companions) {
      total +=
          companion.doctorSkill;
    }

    return total;
  }

  int get vetSkill {
    int total = leader.vetSkill;

    for (final companion
        in companions) {
      total += companion.vetSkill;
    }

    return total;
  }

  int get mechanicSkill {
    int total =
        leader.mechanicSkill;

    for (final companion
        in companions) {
      total +=
          companion.mechanicSkill;
    }

    return total;
  }

  int get scoutSkill {
    int total =
        leader.scoutSkill;

    for (final companion
        in companions) {
      total +=
          companion.scoutSkill;
    }

    return total;
  }

  int get combatSkill {
    int total =
        leader.combatSkill;

    for (final companion
        in companions) {
      total +=
          companion.combatSkill;
    }

    return total;
  }

  double get calorieRequirementPerDay {
    double total =
        leader.caloriesPerDay;

    for (final companion
        in companions) {
      total +=
          companion.caloriesPerDay;
    }

    return total;
  }

  double get wagesPerDay {
    return companions.fold<double>(
      0,
      (total, companion) =>
          total +
          companion.wagePerDay,
    );
  }

  double get waterRequirementPerDay {
    return CaravanService.waterPerDay(
      this,
    );
  }

  double get forageRequirementPerDay {
    return CaravanService.foragePerDay(
      this,
    );
  }

  double get fuelRequirementPerDay {
    return 0;
  }

  double quantityOf(
    String goodId,
  ) {
    final item = inventory.where(
      (item) =>
          item.good.id == goodId,
    );

    if (item.isEmpty) {
      return 0;
    }

    return item.first.quantity;
  }

  Map<String, dynamic> toJson() {
    return {
      'leader': leader.toJson(),
      'companions': companions
          .map(
            (character) =>
                character.toJson(),
          )
          .toList(),
      'gold': gold,
      'inventory': inventory
          .map(
            (item) => item.toJson(),
          )
          .toList(),
          'weapons': weapons
    .map((weapon) => weapon.id)
    .toList(),

'armours': armours
    .map((armour) => armour.id)
    .toList(),

'helmets': helmets
    .map((helmet) => helmet.id)
    .toList(),
      'animals': animals
          .map(
            (animal) =>
                animal.toJson(),
          )
          .toList(),
      'vehicles': vehicles
          .map(
            (vehicle) =>
                vehicle.toJson(),
          )
          .toList(),
      'manifest': manifest
          .map(
            (entry) => entry.toJson(),
          )
          .toList(),
    };
  }

  factory Caravan.fromJson({
    required Map<String, dynamic>
        json,
    required Animal Function(
      Map<String, dynamic> json,
    )
    animalFromJson,
    required Vehicle Function(
      Map<String, dynamic> json,
    )
    vehicleFromJson,
  }) {
    return Caravan(
      leader: Character.fromJson(
        json['leader']
            as Map<String, dynamic>,
        animalFromJson:
            animalFromJson,
        vehicleFromJson:
            vehicleFromJson,
      ),
      companions:
          (json['companions']
                      as List?)
                  ?.map(
                    (character) =>
                        Character.fromJson(
                      character
                          as Map<String,
                              dynamic>,
                      animalFromJson:
                          animalFromJson,
                      vehicleFromJson:
                          vehicleFromJson,
                    ),
                  )
                  .toList() ??
              [],
      gold:
          (json['gold'] as num)
              .toDouble(),
      inventory:
          (json['inventory'] as List)
              .map(
                (item) =>
                    CargoItem.fromJson(
                  item,
                ),
              )
              .toList(),
weapons:
    (json['weapons'] as List?)
            ?.map(
              (id) => weaponForId(
                id as String,
              ),
            )
            .toList() ??
        [],

armours:
    (json['armours'] as List?)
            ?.map(
              (id) => armourForId(
                id as String,
              ),
            )
            .toList() ??
        [],

helmets:
    (json['helmets'] as List?)
            ?.map(
              (id) => helmetForId(
                id as String,
              ),
            )
            .toList() ??
        [],
              
      animals:
          (json['animals'] as List)
              .map(
                (animal) =>
                    animalFromJson(
                  animal
                      as Map<String,
                          dynamic>,
                ),
              )
              .toList(),
      vehicles:
          (json['vehicles'] as List)
              .map(
                (vehicle) =>
                    vehicleFromJson(
                  vehicle
                      as Map<String,
                          dynamic>,
                ),
              )
              .toList(),
      manifest:
          (json['manifest'] as List?)
                  ?.map(
                    (entry) =>
                        CargoManifestEntry
                            .fromJson(
                      entry
                          as Map<String,
                              dynamic>,
                    ),
                  )
                  .toList() ??
              [],
    );
  }
}