import '../caravan/caravan_service.dart';

import 'animal.dart';
import 'cargo_item.dart';
import 'character.dart';
import 'vehicle.dart';

class Caravan {
  Character leader;

  List<Character> companions;

  double gold;

  List<CargoItem> inventory;

  List<Animal> animals;

  List<Vehicle> vehicles;

  Caravan({
    required this.leader,
    required this.companions,
    required this.gold,
    required this.inventory,
    required this.animals,
    required this.vehicles,
  });

  double get cargoCapacityKg =>
      CaravanService.cargoCapacityKg(
        this,
      );

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
    double total =
        leader.caloriesPerDay;

    for (final companion
        in companions) {
      total +=
          companion.caloriesPerDay;
    }

    return total;
  }

  double get wagesPerDay {
    return companions.fold<double>(
      0,
      (total, companion) =>
          total +
          companion.wagePerDay,
    );
  }

  double get waterRequirementPerDay {
    return CaravanService.waterPerDay(
      this,
    );
  }

  double get forageRequirementPerDay {
    return CaravanService.foragePerDay(
      this,
    );
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
      'companions': companions
          .map(
            (character) =>
                character.toJson(),
          )
          .toList(),
      'gold': gold,
      'inventory': inventory
          .map(
            (item) => item.toJson(),
          )
          .toList(),
      'animals': animals
          .map(
            (animal) =>
                animal.toJson(),
          )
          .toList(),
      'vehicles': vehicles
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
      companions:
          (json['companions']
                      as List?)
                  ?.map(
                    (character) =>
                        Character.fromJson(
                      character
                          as Map<String,
                              dynamic>,
                    ),
                  )
                  .toList() ??
              [],
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
                      as Map<String,
                          dynamic>,
                ),
              )
              .toList(),
      vehicles:
          (json['vehicles'] as List)
              .map(
                (vehicle) =>
                    vehicleFromJson(
                  vehicle
                      as Map<String,
                          dynamic>,
                ),
              )
              .toList(),
    );
  }
}