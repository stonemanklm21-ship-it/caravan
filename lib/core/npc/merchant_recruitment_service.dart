import 'dart:math';

import '../caravan/skill_service.dart';
import '../models/character.dart';

class MerchantRecruitmentService {
  static final Random _random =
      Random();

  static Character generateMerchant() {
    return Character(
      id:
          'merchant_${DateTime.now().microsecondsSinceEpoch}_${_random.nextInt(10000)}',
      name: 'Merchant',
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
      combatXp: _randomCombatXp(),
      doctorXp: 0,
      vetXp: 0,
      mechanicXp: 0,
      scoutXp: 0,
    );
  }

  static double _randomCombatXp() {
    return _random.nextDouble() *
        SkillService.xpForLevel(
          20,
        );
  }
}