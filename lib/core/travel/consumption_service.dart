import '../models/caravan.dart';

class ConsumptionService {
  static void consume({
    required Caravan caravan,
    required double days,
  }) {
    _consumeCalories(
      caravan: caravan,
      caloriesRequired:
          caravan.calorieRequirementPerDay * days,
    );

    _consumeGood(
      caravan: caravan,
      goodName: 'Water',
      quantityRequired:
          caravan.waterRequirementPerDay * days,
    );

    _consumeGood(
      caravan: caravan,
      goodName: 'Forage',
      quantityRequired:
          caravan.forageRequirementPerDay * days,
    );

    _consumeGood(
      caravan: caravan,
      goodName: 'Fuel',
      quantityRequired:
          caravan.fuelRequirementPerDay * days,
    );
  }

  static void _consumeCalories({
    required Caravan caravan,
    required double caloriesRequired,
  }) {
    double remainingCalories = caloriesRequired;

    final foodItems = caravan.inventory.where(
      (item) => item.good.caloriesPerUnit > 0,
    );

    for (final item in foodItems.toList()) {
      if (remainingCalories <= 0) {
        break;
      }

      final caloriesPerUnit =
          item.good.caloriesPerUnit;

      final unitsNeeded =
          remainingCalories / caloriesPerUnit;

      final unitsConsumed =
          unitsNeeded > item.quantity
              ? item.quantity
              : unitsNeeded;

      item.quantity -= unitsConsumed;

      remainingCalories -=
          unitsConsumed * caloriesPerUnit;
    }

    caravan.inventory.removeWhere(
      (item) => item.quantity <= 0.0001,
    );
  }

  static void _consumeGood({
    required Caravan caravan,
    required String goodName,
    required double quantityRequired,
  }) {
    final itemIndex =
        caravan.inventory.indexWhere(
      (item) => item.good.name == goodName,
    );

    if (itemIndex < 0) {
      return;
    }

    final item =
        caravan.inventory[itemIndex];

    item.quantity -= quantityRequired;

    if (item.quantity <= 0.0001) {
      caravan.inventory.removeAt(itemIndex);
    }
  }
}