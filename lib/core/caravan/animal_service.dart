import 'dart:math';

import '../models/animal.dart';
import '../models/character.dart';
import '../world/calendar_service.dart';

class AnimalService {
  static final Random _random =
      Random();

  static void advanceTime({
    required Animal animal,
    required double hours,
  }) {
    animal.ageYears +=
        CalendarService.yearsFromHours(
          hours,
        );

    final days =
        hours / 24;

    final yearsPastLifeExpectancy =
        animal.ageYears -
        animal.type.lifeExpectancyYears;

    if (yearsPastLifeExpectancy > 0) {
      final chancePerDay =
          0.005 *
          yearsPastLifeExpectancy;

      final chanceThisUpdate =
          chancePerDay * days;

      if (_random.nextDouble() <
          chanceThisUpdate) {
        animal.hp = 0;
      }
    }
  }

  static void advanceTimeForAll({
    required List<Animal> animals,
    required double hours,
  }) {
    for (final animal in animals) {
      advanceTime(
        animal: animal,
        hours: hours,
      );
    }
  }

  static double maturityFraction(
    Animal animal,
  ) {
    if (animal.ageYears <= 0) {
      return 0;
    }

    if (animal.ageYears >= 5) {
      return 1;
    }

    final x = animal.ageYears / 5;

    return x * x * (3 - 2 * x);
  }

  static double weightKg(
    Animal animal,
  ) {
    return animal.adultWeightKg *
        (0.1 +
            (0.9 *
                maturityFraction(
                  animal,
                )));
  }

  static double cargoCapacityKg(
    Animal animal,
  ) {
    return weightKg(animal) * 0.25;
  }

  static bool canCarryRider({
    required Animal animal,
    required Character character,
  }) {
    return cargoCapacityKg(animal) >=
        character.weightKg;
  }

  static double cargoCapacityWithRiderKg({
    required Animal animal,
    required Character character,
  }) {
    return max(
      0,
      cargoCapacityKg(animal) -
          character.weightKg,
    );
  }

  static double waterPerDay(
    Animal animal,
  ) {
    return weightKg(animal) * 0.02;
  }

  static double foragePerDay(
    Animal animal,
  ) {
    return weightKg(animal) * 0.03;
  }

  static double speed(
    Animal animal,
  ) {
    return animal.type.speed;
  }

  static double hpFraction(
    Animal animal,
  ) {
    return animal.hp /
        animal.type.maxHp;
  }

  static double ageFraction(
    Animal animal,
  ) {
    return animal.ageYears /
        animal.type.lifeExpectancyYears;
  }
}