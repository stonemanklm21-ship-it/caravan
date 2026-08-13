import 'package:flutter/material.dart';

import '../../data/armour_data.dart';
import '../../data/helmet_data.dart';
import '../../data/weapon_data.dart';
import 'animal.dart';
import 'armour.dart';
import 'helmet.dart';
import 'portrait_dna.dart';
import 'vehicle.dart';
import 'weapon.dart';

class Character {
  final String id;
  String name;
  String? cityId;

  /// Optional fixed portrait for story NPCs.
  /// If null, portrait can be generated procedurally.
  PortraitDna? portrait;

  int ageYears;

  final double weightKg;
  final double wagePerDay;

  int strength;
  int endurance;
  int life;
  int fortitude;

  int hp;

  Animal? mountedAnimal;
  Vehicle? mountedVehicle;

  Weapon? weapon;
  Armour? armour;
  Helmet? helmet;

  double doctorXp;
  double vetXp;
  double mechanicXp;
  double scoutXp;
  double combatXp;

  Character({
    required this.id,
    required this.name,
    this.cityId,
    this.portrait,
    required this.ageYears,
    required this.weightKg,
    required this.wagePerDay,
    required this.strength,
    required this.endurance,
    required this.life,
    required this.fortitude,
    required this.hp,
    this.mountedAnimal,
    this.mountedVehicle,
    this.weapon,
    this.armour,
    this.helmet,
    this.doctorXp = 0,
    this.vetXp = 0,
    this.mechanicXp = 0,
    this.scoutXp = 0,
    this.combatXp = 0,
  });

  bool get alive => hp > 0;

  int get cargoCapacityKg =>
      10 + (2 * strength);

  double get speed =>
      3.5 + (0.1 * endurance);

  int get maxHp =>
      50 + (5 * life);

  double get waterPerDay =>
      3.0 - (0.1 * fortitude);

  int get caloriesPerDay =>
      3000 - (100 * fortitude);

  double get equipmentWeightKg {
    return (weapon?.weightKg ?? 0) +
        (armour?.weightKg ?? 0) +
        (helmet?.weightKg ?? 0);
  }

  double get availableCargoCapacityKg {
    return cargoCapacityKg - equipmentWeightKg;
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

    final hpRatio = hp / maxHp;

    final speedModifier =
        0.8 + (hpRatio * 0.2);

    return speed * speedModifier;
  }

  bool get mounted =>
      mountedAnimal != null ||
      mountedVehicle != null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cityId': cityId,
      'ageYears': ageYears,
      'weightKg': weightKg,
      'wagePerDay': wagePerDay,
      'strength': strength,
      'endurance': endurance,
      'life': life,
      'fortitude': fortitude,
      'hp': hp,
      'mountedAnimal':
          mountedAnimal?.toJson(),
      'mountedVehicle':
          mountedVehicle?.toJson(),
      'weapon': weapon?.id,
      'armour': armour?.id,
      'helmet': helmet?.id,
      'doctorXp': doctorXp,
      'vetXp': vetXp,
      'mechanicXp': mechanicXp,
      'scoutXp': scoutXp,
      'combatXp': combatXp,
      'portrait': portrait == null
          ? null
          : {
              'headStyle':
                  portrait!.headStyle,
              'hairStyle':
                  portrait!.hairStyle,
              'eyeStyle':
                  portrait!.eyeStyle,
              'mouthStyle':
                  portrait!.mouthStyle,
              'skinColor':
                  portrait!.skinColor.toARGB32(),
              'hairColor':
                  portrait!.hairColor.toARGB32(),
              'mouthColor':
                  portrait!.mouthColor.toARGB32(),
            },
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
      cityId: json['cityId'] as String?,
      portrait: json['portrait'] == null
          ? null
          : PortraitDna(
              headStyle:
                  json['portrait']['headStyle']
                      as int,
              hairStyle:
                  json['portrait']['hairStyle']
                      as int,
              eyeStyle:
                  json['portrait']['eyeStyle']
                      as int,
              mouthStyle:
                  json['portrait']['mouthStyle']
                      as int,
              skinColor: Color(
                json['portrait']['skinColor']
                    as int,
              ),
              hairColor: Color(
                json['portrait']['hairColor']
                    as int,
              ),
              mouthColor: Color(
                json['portrait']['mouthColor']
                    as int,
              ),
            ),
      ageYears: json['ageYears'] as int,
      weightKg:
          (json['weightKg'] as num)
              .toDouble(),
      wagePerDay:
          (json['wagePerDay'] as num)
              .toDouble(),
      strength:
          json['strength'] as int,
      endurance:
          json['endurance'] as int,
      life:
          json['life'] as int,
      fortitude:
          json['fortitude'] as int,
      hp:
          json['hp'] as int,
      mountedAnimal:
          json['mountedAnimal'] == null
              ? null
              : animalFromJson(
                  json['mountedAnimal']
                      as Map<String, dynamic>,
                ),
      mountedVehicle:
          json['mountedVehicle'] == null
              ? null
              : vehicleFromJson(
                  json['mountedVehicle']
                      as Map<String, dynamic>,
                ),
      weapon: json['weapon'] == null
          ? null
          : weaponForId(
              json['weapon'] as String,
            ),
      armour: json['armour'] == null
          ? null
          : armourForId(
              json['armour'] as String,
            ),
      helmet: json['helmet'] == null
          ? null
          : helmetForId(
              json['helmet'] as String,
            ),
      doctorXp:
          (json['doctorXp'] as num?)
                  ?.toDouble() ??
              0,
      vetXp:
          (json['vetXp'] as num?)
                  ?.toDouble() ??
              0,
      mechanicXp:
          (json['mechanicXp'] as num?)
                  ?.toDouble() ??
              0,
      scoutXp:
          (json['scoutXp'] as num?)
                  ?.toDouble() ??
              0,
      combatXp:
          (json['combatXp'] as num?)
                  ?.toDouble() ??
              0,
    );
  }
}