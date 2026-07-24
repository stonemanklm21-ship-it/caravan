import 'dart:math';

import '../../core/models/armour.dart';
import '../../core/models/bandit_faction.dart';
import '../../core/models/character.dart';
import '../../core/models/helmet.dart';
import '../../core/models/weapon.dart';

import '../../data/armour_data.dart';
import '../../data/helmet_data.dart';
import '../../data/weapon_data.dart';
import '../../data/game_balance.dart';

class BanditEquipmentService {
  static final Random _random = Random();

  static void equipBandit({
    required Character character,
    required BanditFaction faction,
    required bool leader,
  }) {
    character.weapon = _rollWeapon(
      faction: faction,
      leader: leader,
    );

    character.armour = _rollArmour(
      leader: leader,
    );

    character.helmet = _rollHelmet(
      leader: leader,
    );
  }

  static Weapon _rollWeapon({
    required BanditFaction faction,
    required bool leader,
  }) {
    final roll = _random.nextDouble();

    // Leaders are heavily biased towards
    // their faction's preferred weapon.
    if (leader) {
      if (roll <
    GameBalance
        .banditLeaderPreferredWeaponChance)
 {
        return faction.preferredWeapon;
      }

      return weapons[
        _random.nextInt(
          weapons.length,
        )
      ];
    }

    // Most followers use the faction weapon,
    // with some variation.
    if (roll <
    GameBalance
        .banditPreferredWeaponChance) {
      return faction.preferredWeapon;
    }

    return weapons[
      _random.nextInt(
        weapons.length,
      )
    ];
  }

  static Armour? _rollArmour({
    required bool leader,
  }) {
    final roll = _random.nextDouble();

    if (leader) {
      return leatherArmour;
    }

    if (roll < 0.60) return null;
    if (roll < 0.90) return paddedArmour;

    return leatherArmour;
  }

  static Helmet? _rollHelmet({
    required bool leader,
  }) {
    final roll = _random.nextDouble();

    if (leader) {
      return leatherCap;
    }

    if (roll < 0.80) return null;

    return clothCap;
  }
}