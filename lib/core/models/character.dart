import '../../data/armour_data.dart';
import '../../data/helmet_data.dart';
import '../../data/weapon_data.dart';

import 'animal.dart';
import 'armour.dart';
import 'helmet.dart';
import 'vehicle.dart';
import 'weapon.dart';

class Character {
  final String id;

  String name;

  int ageYears;

  final double weightKg;

  final double cargoCapacityKg;

  final double caloriesPerDay;

  final double waterPerDay;

  final double wagePerDay;

  double hp;

  final double maxHp;

  final double speed;

  Animal? mountedAnimal;

  Vehicle? mountedVehicle;

  Weapon? weapon;

  Armour? armour;

  Helmet? helmet;

  int doctorSkill;

  int vetSkill;

  int mechanicSkill;

  int scoutSkill;

  int combatSkill;

  Character({
    required this.id,
    required this.name,
    required this.ageYears,
    required this.weightKg,
    required this.cargoCapacityKg,
    required this.caloriesPerDay,
    required this.waterPerDay,
    required this.wagePerDay,
    required this.hp,
    required this.maxHp,
    required this.speed,
    this.mountedAnimal,
    this.mountedVehicle,
    this.weapon,
    this.armour,
    this.helmet,
    this.doctorSkill = 0,
    this.vetSkill = 0,
    this.mechanicSkill = 0,
    this.scoutSkill = 0,
    this.combatSkill = 0,
  });

  bool get alive => hp > 0;

  double get equipmentWeightKg {
    return (weapon?.weightKg ?? 0) +
        (armour?.weightKg ?? 0) +
        (helmet?.weightKg ?? 0);
  }

  double get availableCargoCapacityKg {
    return cargoCapacityKg -
        equipmentWeightKg;
  }

  int get accuracy {
    return weapon?.accuracy ?? 6;
  }

  int get damageDie {
    return weapon?.damageDie ?? 5;
  }

  int get protection {
    return (armour?.protection ?? 0) +
        (helmet?.protection ?? 0);
  }

  double get effectiveSpeed {
    if (mountedAnimal != null) {
      return mountedAnimal!.type.speed;
    }

    if (mountedVehicle != null) {
      final draftAnimal =
          mountedVehicle!.draftAnimal;

      if (draftAnimal != null) {
        return draftAnimal.type.speed;
      }
    }

    return speed;
  }

  bool get mounted =>
      mountedAnimal != null ||
      mountedVehicle != null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ageYears': ageYears,
      'weightKg': weightKg,
      'cargoCapacityKg': cargoCapacityKg,
      'caloriesPerDay': caloriesPerDay,
      'waterPerDay': waterPerDay,
      'wagePerDay': wagePerDay,
      'hp': hp,
      'maxHp': maxHp,
      'speed': speed,
      'mountedAnimal':
          mountedAnimal?.toJson(),
      'mountedVehicle':
          mountedVehicle?.toJson(),
      'weapon': weapon?.id,
      'armour': armour?.id,
      'helmet': helmet?.id,
      'doctorSkill': doctorSkill,
      'vetSkill': vetSkill,
      'mechanicSkill': mechanicSkill,
      'scoutSkill': scoutSkill,
      'combatSkill': combatSkill,
    };
  }

  factory Character.fromJson(
    Map<String, dynamic> json, {
    required Animal Function(
      Map<String, dynamic> json,
    )
    animalFromJson,
    required Vehicle Function(
      Map<String, dynamic> json,
    )
    vehicleFromJson,
  }) {
    return Character(
      id: json['id'] as String,
      name: json['name'] as String,
      ageYears: json['ageYears'] as int,
      weightKg:
          (json['weightKg'] as num)
              .toDouble(),
      cargoCapacityKg:
          (json['cargoCapacityKg']
                  as num)
              .toDouble(),
      caloriesPerDay:
          (json['caloriesPerDay']
                  as num)
              .toDouble(),
      waterPerDay:
          (json['waterPerDay']
                  as num)
              .toDouble(),
      wagePerDay:
          (json['wagePerDay']
                  as num)
              .toDouble(),
      hp:
          (json['hp'] as num)
              .toDouble(),
      maxHp:
          (json['maxHp'] as num)
              .toDouble(),
      speed:
          (json['speed'] as num)
              .toDouble(),
      mountedAnimal:
          json['mountedAnimal'] == null
              ? null
              : animalFromJson(
                  json['mountedAnimal']
                      as Map<String,
                          dynamic>,
                ),
      mountedVehicle:
          json['mountedVehicle'] == null
              ? null
              : vehicleFromJson(
                  json['mountedVehicle']
                      as Map<String,
                          dynamic>,
                ),
      weapon:
          json['weapon'] == null
              ? null
              : weaponForId(
                  json['weapon']
                      as String,
                ),
      armour:
          json['armour'] == null
              ? null
              : armourForId(
                  json['armour']
                      as String,
                ),
      helmet:
          json['helmet'] == null
              ? null
              : helmetForId(
                  json['helmet']
                      as String,
                ),
      doctorSkill:
          json['doctorSkill']
                  as int? ??
              0,
      vetSkill:
          json['vetSkill'] as int? ??
              0,
      mechanicSkill:
          json['mechanicSkill']
                  as int? ??
              0,
      scoutSkill:
          json['scoutSkill'] as int? ??
              0,
      combatSkill:
          json['combatSkill']
                  as int? ??
              0,
    );
  }
}