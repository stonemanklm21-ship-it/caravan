import 'dart:math';

import '../models/caravan.dart';
import '../models/character.dart';

import 'combat_round_result.dart';

class CombatService {
  static final Random _random =
      Random();

  static List<Character>
      combatants(
    Caravan caravan,
  ) {
    return [
      caravan.leader,
      ...caravan.companions,
    ]
        .where(
          (character) =>
              character.alive,
        )
        .toList();
  }

  static bool hits(
    Character attacker,
  ) {
    final roll =
        _random.nextInt(10) + 1;

    return roll <= attacker.accuracy;
  }

  static int attackRoll(
    Character attacker,
  ) {
    final ceiling =
        attacker.combatSkill +
        attacker.damageDie;

    return _random.nextInt(
      ceiling + 1,
    );
  }

  static int defenceRoll(
    Character defender,
  ) {
    final ceiling =
        defender.combatSkill +
        defender.protection;

    return _random.nextInt(
      ceiling + 1,
    );
  }

  static int damage({
    required Character attacker,
    required Character defender,
  }) {
    if (!hits(attacker)) {
      return 0;
    }

    final attack =
        attackRoll(attacker);

    final defence =
        defenceRoll(defender);

    return max(
      0,
      attack - defence,
    );
  }

  static CombatRoundResult attack({
    required Character attacker,
    required Character defender,
  }) {
    final wasHit =
        hits(attacker);

    if (!wasHit) {
      return CombatRoundResult(
        attacker: attacker,
        defender: defender,
        result: CombatResultType.miss,
        damage: 0,
      );
    }

    final attack =
        attackRoll(attacker);

    final defence =
        defenceRoll(defender);

    final damageAmount =
        max(
      0,
      attack - defence,
    );

    if (damageAmount == 0) {
      return CombatRoundResult(
        attacker: attacker,
        defender: defender,
        result: CombatResultType.block,
        damage: 0,
      );
    }

    defender.hp -= damageAmount;

    if (defender.hp < 0) {
      defender.hp = 0;
    }

    return CombatRoundResult(
      attacker: attacker,
      defender: defender,
      result: CombatResultType.hit,
      damage: damageAmount,
    );
  }

  static List<CombatRoundResult>
      resolveRound({
    required List<Character> attackers,
    required List<Character> defenders,
  }) {
    final results =
        <CombatRoundResult>[];

    final livingAttackers =
        attackers
            .where(
              (character) =>
                  character.alive,
            )
            .toList();

    livingAttackers.sort(
      (a, b) =>
          b.combatSkill.compareTo(
        a.combatSkill,
      ),
    );

    for (final attacker
        in livingAttackers) {
      final livingDefenders =
          defenders
              .where(
                (character) =>
                    character.alive,
              )
              .toList();

      if (livingDefenders.isEmpty) {
        break;
      }

      final defender =
          livingDefenders[
              _random.nextInt(
        livingDefenders.length,
      )];

      results.add(
        attack(
          attacker: attacker,
          defender: defender,
        ),
      );
    }

    return results;
  }
}