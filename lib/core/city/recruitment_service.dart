  import 'dart:math';

  import '../models/character.dart';
  import '../models/city.dart';
  import '../models/recruit.dart';

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

    static Recruit generateRecruit({
      required RecruitmentMarketTier tier,
    }) {
      final age =
          18 + _random.nextInt(43);

      final maxSkill = switch (tier) {
        RecruitmentMarketTier.basic =>
          20,
        RecruitmentMarketTier
              .regional =>
          40,
        RecruitmentMarketTier.major =>
          60,
      };

      final doctorSkill =
          _random.nextInt(
        maxSkill + 1,
      );

      final vetSkill =
          _random.nextInt(
        maxSkill + 1,
      );

      final mechanicSkill =
          _random.nextInt(
        maxSkill + 1,
      );

      final scoutSkill =
          _random.nextInt(
        maxSkill + 1,
      );

      final combatSkill =
          _random.nextInt(
        maxSkill + 1,
      );

      final totalSkill =
          doctorSkill +
          vetSkill +
          mechanicSkill +
          scoutSkill +
          combatSkill;

      final wage =
          (100 +
                  (totalSkill * 2))
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
            (_random.nextDouble() *
                45),
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
        doctorSkill: doctorSkill,
        vetSkill: vetSkill,
        mechanicSkill:
            mechanicSkill,
        scoutSkill: scoutSkill,
        combatSkill:
            combatSkill,
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