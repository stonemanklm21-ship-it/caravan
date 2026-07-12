import 'dart:math';

import '../../data/animal_data.dart';
import '../models/animal.dart';
import '../models/animal_type.dart';
import '../models/city.dart';
import '../caravan/animal_service.dart';

enum AnimalMarketTier {
  basic,
  regional,
  major,
}

class AnimalMarketService {
  static final Random _random =
      Random();

  static List<Animal> marketStock({
    required City city,
    required int currentHour,
    int stockSize = 10,
  }) {
    final tier =
        city.animalMarketTier;

    if (tier == null) {
      return [];
    }

    final hoursSinceRefresh =
        currentHour -
        city
            .lastAnimalMarketRefreshHour;

    if (city.animalMarketStock
            .isEmpty ||
        hoursSinceRefresh >= 72) {
      city.animalMarketStock =
          generateStock(
        tier: tier,
        stockSize: stockSize,
      );

      city
          .lastAnimalMarketRefreshHour =
          currentHour;
    }

    return city.animalMarketStock;
  }

  static List<AnimalType>
      availableAnimals(
    AnimalMarketTier tier,
  ) {
    switch (tier) {
      case AnimalMarketTier.basic:
        return [
          donkey,
        ];

      case AnimalMarketTier.regional:
        return [
          donkey,
          horse,
        ];

      case AnimalMarketTier.major:
        return [
          donkey,
          horse,
          ox,
          camel,
        ];
    }
  }

  static List<Animal> generateStock({
    required AnimalMarketTier tier,
    required int stockSize,
  }) {
    final types =
        availableAnimals(tier);

    return List.generate(
      stockSize,
      (_) {
        final type =
            types[_random.nextInt(
          types.length,
        )];

        return generateAnimal(
          type,
        );
      },
    );
  }

  static Animal generateAnimal(
    AnimalType type,
  ) {
    final ageYears =
        1 +
        (_random.nextDouble() * 19);

    final adultWeightKg =
        type.averageAdultWeightKg *
        (0.9 +
            (_random.nextDouble() *
                0.2));

    final hp =
        type.maxHp *
        (0.8 +
            (_random.nextDouble() *
                0.2));

    return Animal(
      type: type,
      gender:
          _random.nextBool()
              ? AnimalGender.male
              : AnimalGender.female,
      hp: hp,
      ageYears: ageYears,
      adultWeightKg:
          adultWeightKg,
    );
  }

  static double price(
    Animal animal,
  ) {
    final hpFactor =
        AnimalService.hpFraction(
          animal,
        );

    final weightFactor =
        animal.adultWeightKg /
        animal.type
            .averageAdultWeightKg;

    double ageFactor = 1.0;

    if (animal.ageYears < 5) {
      ageFactor =
          0.5 +
          ((animal.ageYears / 5) *
              0.5);
    } else {
      final ageFraction =
          AnimalService.ageFraction(
            animal,
          );

      if (ageFraction > 0.8) {
        ageFactor =
            1 -
            (((ageFraction - 0.8) /
                    0.2) *
                0.5);

        if (ageFactor < 0.5) {
          ageFactor = 0.5;
        }
      }
    }

    return animal.type.basePrice *
        hpFactor *
        weightFactor *
        ageFactor;
  }
}