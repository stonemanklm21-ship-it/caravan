import '../../data/goods_data.dart';
import '../models/caravan.dart';

class ConsumptionService {
  static void consume({
    required Caravan caravan,
    required double days,
  }) {
    final caloriesRequired =
        caravan.calorieRequirementPerDay *
        days;

    final waterRequired =
        caravan.waterRequirementPerDay *
        days;

    final forageRequired =
        caravan.forageRequirementPerDay *
        days;

    final calorieShortfall =
        _consumeCalories(
      caravan: caravan,
      caloriesRequired:
          caloriesRequired,
    );

    final waterShortfall =
        _consumeGood(
      caravan: caravan,
      goodId: water.id,
      quantityRequired:
          waterRequired,
    );

    final forageShortfall =
        _consumeGood(
      caravan: caravan,
      goodId: forage.id,
      quantityRequired:
          forageRequired,
    );

    _applyCharacterDamage(
      caravan: caravan,
      calorieShortfall:
          calorieShortfall,
      caloriesRequired:
          caloriesRequired,
      waterShortfall:
          waterShortfall,
      waterRequired:
          waterRequired,
      days: days,
    );

    _applyAnimalDamage(
      caravan: caravan,
      forageShortfall:
          forageShortfall,
      forageRequired:
          forageRequired,
      waterShortfall:
          waterShortfall,
      waterRequired:
          waterRequired,
      days: days,
    );
  }

  static double _consumeCalories({
    required Caravan caravan,
    required double caloriesRequired,
  }) {
    double remainingCalories =
        caloriesRequired;

    final foodItems = caravan.inventory.where(
      (item) =>
          item.good.caloriesPerUnit > 0,
    );

    for (final item in foodItems.toList()) {
      if (remainingCalories <= 0) {
        break;
      }

      final caloriesPerUnit =
          item.good.caloriesPerUnit;

      final unitsNeeded =
          remainingCalories /
          caloriesPerUnit;

      final unitsConsumed =
          unitsNeeded > item.quantity
              ? item.quantity
              : unitsNeeded;

      item.quantity -= unitsConsumed;

      remainingCalories -=
          unitsConsumed *
          caloriesPerUnit;
    }

    caravan.inventory.removeWhere(
      (item) => item.quantity <= 0.0001,
    );

    return remainingCalories;
  }

  static double _consumeGood({
    required Caravan caravan,
    required String goodId,
    required double quantityRequired,
  }) {
    final itemIndex =
        caravan.inventory.indexWhere(
      (item) => item.good.id == goodId,
    );

    if (itemIndex < 0) {
      return quantityRequired;
    }

    final item =
        caravan.inventory[itemIndex];

    if (item.quantity >=
        quantityRequired) {
      item.quantity -= quantityRequired;

      if (item.quantity <= 0.0001) {
        caravan.inventory.removeAt(
          itemIndex,
        );
      }

      return 0;
    }

    final shortfall =
        quantityRequired - item.quantity;

    caravan.inventory.removeAt(
      itemIndex,
    );

    return shortfall;
  }

  static void _applyCharacterDamage({
    required Caravan caravan,
    required double calorieShortfall,
    required double caloriesRequired,
    required double waterShortfall,
    required double waterRequired,
    required double days,
  }) {
    double damage = 0;

    if (caloriesRequired > 0) {
      damage +=
          5 *
          days *
          (calorieShortfall /
              caloriesRequired);
    }

    if (waterRequired > 0) {
      damage +=
          10 *
          days *
          (waterShortfall /
              waterRequired);
    }

    caravan.leader.hp =
        (caravan.leader.hp - damage)
            .clamp(
      0,
      caravan.leader.maxHp,
    );

    for (final companion
        in caravan.companions) {
      companion.hp =
          (companion.hp - damage)
              .clamp(
        0,
        companion.maxHp,
      );
    }
  }

  static void _applyAnimalDamage({
    required Caravan caravan,
    required double forageShortfall,
    required double forageRequired,
    required double waterShortfall,
    required double waterRequired,
    required double days,
  }) {
    double damage = 0;

    if (forageRequired > 0) {
      damage +=
          5 *
          days *
          (forageShortfall /
              forageRequired);
    }

    if (waterRequired > 0) {
      damage +=
          10 *
          days *
          (waterShortfall /
              waterRequired);
    }

    for (final animal
        in caravan.animals) {
      animal.hp =
          (animal.hp - damage)
              .clamp(
        0,
        animal.type.maxHp,
      );
    }
  }
}