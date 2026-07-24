import 'dart:math';

import '../caravan/skill_service.dart';
import '../models/bandit_faction.dart';
import '../models/character.dart';

class BanditRecruitmentService {
  static final Random _random =
      Random();

  static Character generateBandit({
    required BanditFaction faction,
  }) {
    final combatXp = _randomCombatXp(
      faction.maxCombatLevel,
    );

    return Character(
      id:
          'bandit_${DateTime.now().microsecondsSinceEpoch}_${_random.nextInt(10000)}',
      name: faction.name,
      ageYears:
          18 + _random.nextInt(43),
      weightKg:
          55 +
          (_random.nextDouble() * 45),
      cargoCapacityKg: 10,
      caloriesPerDay: 2500,
      waterPerDay: 3,
      wagePerDay: 0,
      hp: 100,
      maxHp: 100,
      speed:
          3 +
          (_random.nextDouble() * 3),
      combatXp: combatXp,
      doctorXp: 0,
      vetXp: 0,
      mechanicXp: 0,
      scoutXp: 0,
    );
  }

  static double _randomCombatXp(
    int maxLevel,
  ) {
    return pow(
          _random.nextDouble(),
          2,
        ) *
        SkillService.xpForLevel(
          maxLevel,
        );
  }
}