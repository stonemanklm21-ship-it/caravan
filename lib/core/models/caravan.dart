import 'cargo_item.dart';
import 'caravan_component_stack.dart';

class Caravan {
  double gold;

  List<CargoItem> inventory;

  List<CaravanComponentStack> components;

  Caravan({
    required this.gold,
    required this.inventory,
    required this.components,
  });

  double get cargoCapacityKg {
    return components.fold<double>(
      0,
      (total, stack) =>
          total +
          (stack.component.cargoCapacityKg * stack.quantity),
    );
  }

  double get cargoWeightKg {
    return inventory.fold<double>(
      0,
      (total, item) =>
          total + (item.good.weight * item.quantity),
    );
  }

  double get availableCapacityKg {
    return cargoCapacityKg - cargoWeightKg;
  }

  double get speed {
    if (components.isEmpty) {
      return 0;
    }

    return components
        .map((stack) => stack.component.travelSpeed)
        .reduce((a, b) => a < b ? a : b);
  }

  double get calorieRequirementPerDay {
    return components.fold<double>(
      0,
      (total, stack) =>
          total +
          (stack.component.caloriesPerDay * stack.quantity),
    );
  }

  double get waterRequirementPerDay {
    return components.fold<double>(
      0,
      (total, stack) =>
          total +
          (stack.component.waterPerDay * stack.quantity),
    );
  }

  double get forageRequirementPerDay {
    return components.fold<double>(
      0,
      (total, stack) =>
          total +
          (stack.component.foragePerDay * stack.quantity),
    );
  }

  double get fuelRequirementPerDay {
    return components.fold<double>(
      0,
      (total, stack) =>
          total +
          (stack.component.fuelPerDay * stack.quantity),
    );
  }

  double quantityOf(String goodId) {
    final item = inventory.where(
      (item) => item.good.id == goodId,
    );

    if (item.isEmpty) {
      return 0;
    }

    return item.first.quantity;
  }

  Map<String, dynamic> toJson() {
    return {
      'gold': gold,
      'inventory':
          inventory
              .map((item) => item.toJson())
              .toList(),
      'components':
          components
              .map((component) =>
                  component.toJson())
              .toList(),
    };
  }

  factory Caravan.fromJson(
    Map<String, dynamic> json,
  ) {
    return Caravan(
      gold:
          (json['gold'] as num)
              .toDouble(),
      inventory:
          (json['inventory'] as List)
              .map(
                (item) =>
                    CargoItem.fromJson(
                  item,
                ),
              )
              .toList(),
      components:
          (json['components'] as List)
              .map(
                (component) =>
                    CaravanComponentStack
                        .fromJson(
                  component,
                ),
              )
              .toList(),
    );
  }
}