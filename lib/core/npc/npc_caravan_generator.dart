import 'dart:math';

import '../../data/animal_data.dart';
import '../../data/caravan_templates.dart';
import '../../data/vehicle_data.dart';
import '../city/recruitment_service.dart';
import '../caravan/animal_service.dart';
import '../economy/market_ledger.dart';
import '../models/animal.dart';
import '../models/caravan.dart';
import '../models/city.dart';
import '../models/npc_caravan.dart';
import '../models/vehicle.dart';

class NpcCaravanGenerator {
  static final Random _random =
      Random();

  static List<NpcCaravan> generate({
    required List<City> cities,
  }) {
    final caravans = <NpcCaravan>[];

    for (final city in cities) {
      final traderCount = max(
        1,
        city.population ~/ 1000,
      );

      for (
        int i = 0;
        i < traderCount;
        i++
      ) {
        final template =
            _randomTemplate();

        caravans.add(
          NpcCaravan(
            worldX: city.x,
            worldY: city.y,
            currentCity: city,
            caravan:
                _buildCaravan(template),
            ledger: MarketLedger(
              observations: [],
            ),
          ),
        );
      }
    }

    return caravans;
  }

  static CaravanTemplate
      _randomTemplate() {
    final totalWeight =
        caravanTemplates.fold(
      0,
      (sum, template) =>
          sum + template.weight,
    );

    int roll =
        _random.nextInt(totalWeight);

    for (final template
        in caravanTemplates) {
      roll -= template.weight;

      if (roll < 0) {
        return template;
      }
    }

    return caravanTemplates.first;
  }

  static Caravan _buildCaravan(
    CaravanTemplate template,
  ) {

final leader =
    RecruitmentService
        .generateRecruit(
          tier:
              RecruitmentMarketTier.major,
        )
        .character;

final companions =
    List.generate(
  template.companions,
  (_) => RecruitmentService
      .generateRecruit(
        tier:
            RecruitmentMarketTier.major,
      ).character,
);

    final animals = <Animal>[];

    for (
      int i = 0;
      i < template.donkeys;
      i++
    ) {
      animals.add(
        _animal(donkey),
      );
    }

    for (
      int i = 0;
      i < template.horses;
      i++
    ) {
      animals.add(
        _animal(horse),
      );
    }

    for (
      int i = 0;
      i < template.ox;
      i++
    ) {
      animals.add(
        _animal(ox),
      );
    }

    for (
      int i = 0;
      i < template.camels;
      i++
    ) {
      animals.add(
        _animal(camel),
      );
    }

    final vehicles = <Vehicle>[];

    for (
      int i = 0;
      i < template.smallCarts;
      i++
    ) {
      vehicles.add(
        Vehicle(
          type: smallCart,
          condition: 100,
        ),
      );
    }

    for (
      int i = 0;
      i < template.carts;
      i++
    ) {
      vehicles.add(
        Vehicle(
          type: cart,
          condition: 100,
        ),
      );
    }

    for (
      int i = 0;
      i < template.largeCarts;
      i++
    ) {
      vehicles.add(
        Vehicle(
          type: largeCart,
          condition: 100,
        ),
      );
    }

    final availableAnimals =
        List<Animal>.from(animals);

    for (final vehicle in vehicles) {
      availableAnimals.sort(
        (a, b) =>
            AnimalService
                .cargoCapacityKg(b)
                .compareTo(
                  AnimalService
                      .cargoCapacityKg(a),
                ),
      );

      Animal? draftAnimal;

      for (final animal
          in availableAnimals) {
        if (AnimalService
                .cargoCapacityKg(
              animal,
            ) >=
            vehicle
                .type
                .requiredPullingCapacityKg) {
          draftAnimal = animal;
          break;
        }
      }

      if (draftAnimal != null) {
        vehicle.draftAnimal =
            draftAnimal;

        availableAnimals.remove(
          draftAnimal,
        );
      }
    }

    return Caravan(
      leader: leader,
      companions: companions,
      gold:
          template.minGold +
          (_random.nextDouble() *
              (template.maxGold -
                  template.minGold)),
      inventory: [],
      animals: animals,
      vehicles: vehicles,
      manifest: [],
    );
  }

static Animal _animal(
  dynamic type,
) {
  return Animal(
    type: type,
    gender:
        _random.nextBool()
            ? AnimalGender.male
            : AnimalGender.female,
    hp: type.maxHp.toDouble(),
    ageYears:
        2 + (_random.nextDouble() * 10),
    adultWeightKg:
        type.averageAdultWeightKg *
        (0.9 +
            (_random.nextDouble() * 0.2)),
  );
}
}