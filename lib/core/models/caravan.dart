import 'animal.dart';
import 'cargo_item.dart';
import 'character.dart';
import 'vehicle.dart';

class Caravan {
  Character leader;

  double gold;

  List<CargoItem> inventory;

  List<Animal> animals;

  List<Vehicle> vehicles;

  Caravan({
    required this.leader,
    required this.gold,
    required this.inventory,
    required this.animals,
    required this.vehicles,
  });

  double get cargoCapacityKg {
    return leader.cargoCapacityKg;
  }

  double get cargoWeightKg {
    return inventory.fold<double>(
      0,
      (total, item) =>
          total +
          (item.good.weight *
              item.quantity),
    );
  }

  double get availableCapacityKg {
    return cargoCapacityKg -
        cargoWeightKg;
  }

  double get speed {
    return 1;
  }

  double get calorieRequirementPerDay {
    return leader.caloriesPerDay;
  }

  double get waterRequirementPerDay {
    return leader.waterPerDay;
  }

  double get forageRequirementPerDay {
    return 0;
  }

  double get fuelRequirementPerDay {
    return 0;
  }

  double quantityOf(
    String goodId,
  ) {
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
      'leader': leader.toJson(),
      'gold': gold,
      'inventory':
          inventory
              .map(
                (item) =>
                    item.toJson(),
              )
              .toList(),
      'animals':
          animals
              .map(
                (animal) =>
                    animal.toJson(),
              )
              .toList(),
      'vehicles':
          vehicles
              .map(
                (vehicle) =>
                    vehicle.toJson(),
              )
              .toList(),
    };
  }

  factory Caravan.fromJson({
    required Map<String, dynamic>
        json,
    required Animal Function(
      Map<String, dynamic> json,
    )
    animalFromJson,
    required Vehicle Function(
      Map<String, dynamic> json,
    )
    vehicleFromJson,
  }) {
    return Caravan(
      leader: Character.fromJson(
        json['leader']
            as Map<String, dynamic>,
      ),
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
      animals:
          (json['animals'] as List)
              .map(
                (animal) =>
                    animalFromJson(
                  animal
                      as Map<String, dynamic>,
                ),
              )
              .toList(),
      vehicles:
          (json['vehicles'] as List)
              .map(
                (vehicle) =>
                    vehicleFromJson(
                  vehicle
                      as Map<String, dynamic>,
                ),
              )
              .toList(),
    );
  }
}