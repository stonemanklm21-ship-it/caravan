import '../models/vehicle.dart';
import 'animal_service.dart';

class VehicleService {
  static void advanceTime({
    required Vehicle vehicle,
    required double hours,
  }) {
    vehicle.condition -=
        (hours / 24) * 5;

    if (vehicle.condition < 0) {
      vehicle.condition = 0;
    }
  }

  static void advanceTimeForAll({
    required List<Vehicle> vehicles,
    required double hours,
  }) {
    for (final vehicle in vehicles) {
      advanceTime(
        vehicle: vehicle,
        hours: hours,
      );
    }
  }

  static void repair({
    required Vehicle vehicle,
    required double amount,
  }) {
    vehicle.condition += amount;

    if (vehicle.condition >
        vehicle.type.maxCondition) {
      vehicle.condition =
          vehicle.type.maxCondition;
    }
  }

  static bool operational(
    Vehicle vehicle,
  ) {
    return vehicle.condition > 0;
  }

  static bool canPull(
    Vehicle vehicle,
  ) {
    final animal =
        vehicle.draftAnimal;

    if (animal == null) {
      return false;
    }

    return AnimalService
            .cargoCapacityKg(
          animal,
        ) >=
        vehicle.type
            .requiredPullingCapacityKg;
  }

  static double conditionFraction(
    Vehicle vehicle,
  ) {
    return vehicle.condition /
        vehicle.type.maxCondition;
  }

  static double effectiveCapacityMultiplier(
    Vehicle vehicle,
  ) {
    return vehicle.type
            .capacityMultiplier *
        conditionFraction(vehicle);
  }

  static double effectiveMaxCargoKg(
    Vehicle vehicle,
  ) {
    return vehicle.type.maxCargoKg *
        conditionFraction(vehicle);
  }

  static double cargoCapacityKg(
    Vehicle vehicle,
  ) {
    if (!operational(vehicle) ||
        !canPull(vehicle)) {
      return 0;
    }

    final pullingCapacity =
        AnimalService
            .cargoCapacityKg(
          vehicle.draftAnimal!,
        );

    final capacity =
        pullingCapacity *
        effectiveCapacityMultiplier(
          vehicle,
        );

    final maxCapacity =
        effectiveMaxCargoKg(
          vehicle,
        );

    return capacity < maxCapacity
        ? capacity
        : maxCapacity;
  }
}