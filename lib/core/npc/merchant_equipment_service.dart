import 'dart:math';

import '../../core/models/armour.dart';
import '../../core/models/character.dart';
import '../../core/models/helmet.dart';
import '../../core/models/weapon.dart';

import '../../data/armour_data.dart';
import '../../data/helmet_data.dart';
import '../../data/weapon_data.dart';

class MerchantEquipmentService {
  static final Random _random =
      Random();

  static void equipMerchant({
    required Character character,
    required bool leader,
  }) {
    character.weapon = _rollWeapon(
      leader: leader,
    );

    character.armour = _rollArmour(
      leader: leader,
    );

    character.helmet = _rollHelmet(
      leader: leader,
    );
  }

  static Weapon? _rollWeapon({
    required bool leader,
  }) {
    final roll = _random.nextDouble();

    if (leader) {
      if (roll < 0.50) return knife;
      if (roll < 0.80) return club;
      if (roll < 0.95) return spear;

      return sword;
    }

    if (roll < 0.40) return null;
    if (roll < 0.75) return club;
    if (roll < 0.95) return knife;

    return spear;
  }

  static Armour? _rollArmour({
    required bool leader,
  }) {
    final roll = _random.nextDouble();

    if (leader) {
      if (roll < 0.60) return null;

      return paddedArmour;
    }

    if (roll < 0.85) return null;

    return paddedArmour;
  }

  static Helmet? _rollHelmet({
    required bool leader,
  }) {
    final roll = _random.nextDouble();

    if (leader) {
      if (roll < 0.75) return null;

      return clothCap;
    }

    if (roll < 0.95) return null;

    return clothCap;
  }
}