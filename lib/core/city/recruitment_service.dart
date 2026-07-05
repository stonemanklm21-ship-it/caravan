import 'dart:math';

import '../models/character.dart';
import '../models/recruit.dart';

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

  static List<Recruit>
      generateRecruits({
    int count = 5,
  }) {
    return List.generate(
      count,
      (_) => generateRecruit(),
    );
  }

  static Recruit generateRecruit() {
    final age =
        18 + _random.nextInt(43);

    final wage =
        (1 +
                _random.nextInt(10))
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