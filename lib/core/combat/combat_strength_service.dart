import '../../data/game_balance.dart';

import '../caravan/skill_service.dart';
import '../models/caravan.dart';
import '../models/character.dart';
import '../models/skill.dart';

class CombatStrengthService {
  static double characterStrength(
    Character character,
  ) {
    if (!character.alive) {
      return 0;
    }

    final combatLevel =
        SkillService.getLevel(
      character,
      Skill.combat,
    );

    final hpFraction =
        character.hp / character.maxHp;

    return
        (combatLevel *
            GameBalance
                .combatStrengthCombatLevelWeight) +
        (character.damageDie *
            GameBalance
                .combatStrengthDamageWeight) +
        (character.protection *
            GameBalance
                .combatStrengthProtectionWeight) +
        (hpFraction *
            GameBalance
                .combatStrengthHpWeight);
  }

  static double caravanStrength(
    Caravan caravan,
  ) {
    double total = 0;

    total += characterStrength(
      caravan.leader,
    );

    for (final companion
        in caravan.companions) {
      total += characterStrength(
        companion,
      );
    }

    return total;
  }

  static void debugCaravan({
    required String name,
    required Caravan caravan,
  }) {

    final leaderStrength =
        characterStrength(
      caravan.leader,
    );


    for (int i = 0;
        i < caravan.companions.length;
        i++) {
      final companion =
          caravan.companions[i];

    }
  }

  static double strengthRatio({
    required Caravan attacker,
    required Caravan defender,
  }) {
    final attackerStrength =
        caravanStrength(attacker);

    final defenderStrength =
        caravanStrength(defender);

    if (defenderStrength <= 0) {
      return double.infinity;
    }

    return attackerStrength /
        defenderStrength;
  }
}