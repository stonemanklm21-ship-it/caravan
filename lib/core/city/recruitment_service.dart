import 'dart:math';

import '../models/character.dart';
import '../models/city.dart';
import '../models/recruit.dart';
import '../caravan/skill_service.dart';

enum RecruitmentMarketTier {
  basic,
  regional,
  major,
}

class RecruitmentService {
  static final Random _random =
      Random();

  static const _names = [
    'Thomas',
    'Marcus',
    'Edwin',
    'William',
    'John',
    'Alice',
    'Mary',
    'Sarah',
    'Emma',
    'Clara',
  ];

  static List<Recruit> marketStock({
    required City city,
    required RecruitmentMarketTier tier,
    required int currentHour,
    int stockSize = 5,
  }) {
    final hoursSinceRefresh =
        currentHour -
        city.lastRecruitRefreshHour;

    if (city.recruits.isEmpty ||
        hoursSinceRefresh >= 72) {
      city.recruits =
          generateRecruits(
        tier: tier,
        count: stockSize,
      );

      city.lastRecruitRefreshHour =
          currentHour;
    }

    return city.recruits;
  }

  static List<Recruit>
      generateRecruits({
    required RecruitmentMarketTier tier,
    int count = 5,
  }) {
    return List.generate(
      count,
      (_) => generateRecruit(
        tier: tier,
      ),
    );
  }

  static double _randomSkillXp(
    double maxXp,
  ) {
    return pow(
          _random.nextDouble(),
          2,
        ) *
        maxXp;
  }

  static Recruit generateRecruit({
    required RecruitmentMarketTier tier,
  }) {
    final age =
        18 + _random.nextInt(43);

    final maxXp = switch (tier) {
      RecruitmentMarketTier.basic =>
        SkillService.xpForLevel(20),
      RecruitmentMarketTier.regional =>
        SkillService.xpForLevel(40),
      RecruitmentMarketTier.major =>
        SkillService.xpForLevel(60),
    };

    final doctorXp =
        _randomSkillXp(maxXp);

    final vetXp =
        _randomSkillXp(maxXp);

    final mechanicXp =
        _randomSkillXp(maxXp);

    final scoutXp =
        _randomSkillXp(maxXp);

    final combatXp =
        _randomSkillXp(maxXp);

    final totalSkill =
        SkillService.levelForXp(
          doctorXp,
        ) +
        SkillService.levelForXp(
          vetXp,
        ) +
        SkillService.levelForXp(
          mechanicXp,
        ) +
        SkillService.levelForXp(
          scoutXp,
        ) +
        SkillService.levelForXp(
          combatXp,
        );

    final wage =
        (100 + (totalSkill * 2))
            .toDouble();

    final character = Character(
      id:
          'recruit_${DateTime.now().microsecondsSinceEpoch}_${_random.nextInt(10000)}',
      name:
          _names[
              _random.nextInt(
            _names.length,
          )],
      ageYears: age,
      weightKg:
          55 +
          (_random.nextDouble() * 45),
      cargoCapacityKg:
          (8 +
                  _random.nextInt(
                13,
              ))
              .toDouble(),
      caloriesPerDay: 2500,
      waterPerDay: 3,
      wagePerDay: wage,
      hp: 100,
      maxHp: 100,
      speed:
          3 +
          (_random.nextDouble() * 3),
      doctorXp: doctorXp,
      vetXp: vetXp,
      mechanicXp: mechanicXp,
      scoutXp: scoutXp,
      combatXp: combatXp,
    );

    return Recruit(
      character: character,
      hiringCost: wage * 30,
    );
  }

  static void recruit({
    required Character recruit,
    required List<Character>
        companions,
  }) {
    companions.add(recruit);
  }
}