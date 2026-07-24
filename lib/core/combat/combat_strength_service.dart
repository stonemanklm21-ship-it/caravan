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
        (combatLevel * 5) +
        (character.damageDie * 3) +
        (character.protection * 2) +
        (hpFraction * 20);
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
}