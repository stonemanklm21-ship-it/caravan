import 'dart:math';

import '../caravan/skill_service.dart';
import '../models/character.dart';

class MerchantRecruitmentService {
  static final Random _random =
      Random();

  static Character generateMerchant() {
    const maxSelf = 40;

    final totalSelf =
        _random.nextInt(maxSelf + 1);

    int strength = 0;
    int endurance = 0;
    int life = 0;
    int fortitude = 0;

    for (int i = 0;
        i < totalSelf;
        i++) {
      switch (_random.nextInt(4)) {
        case 0:
          strength++;
          break;
        case 1:
          endurance++;
          break;
        case 2:
          life++;
          break;
        case 3:
          fortitude++;
          break;
      }
    }

    return Character(
      id:
          'merchant_${DateTime.now().microsecondsSinceEpoch}_${_random.nextInt(10000)}',
      name: 'Merchant',
      ageYears:
          18 + _random.nextInt(43),
      weightKg:
          55 +
          (_random.nextDouble() * 45),
      wagePerDay: 0,
      strength: strength,
      endurance: endurance,
      life: life,
      fortitude: fortitude,
      hp: 50 + (5 * life),
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