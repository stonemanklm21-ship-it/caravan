import '../models/animal.dart';
import '../models/caravan.dart';
import '../models/vehicle.dart';
import 'animal_service.dart';
import 'vehicle_service.dart';

class CaravanService {
static double cargoCapacityKg(
  Caravan caravan,
) {
  final vehicleCapacity =
      caravan.vehicles.fold<double>(
    0,
    (total, vehicle) =>
        total +
        VehicleService
            .cargoCapacityKg(
          vehicle,
        ),
  );

  final companionCapacity =
      caravan.companions.fold<double>(
    0,
    (total, companion) =>
        total +
        companion
            .cargoCapacityKg,
  );

  return caravan
          .leader
          .cargoCapacityKg +
      companionCapacity +
      vehicleCapacity;
}

  static double waterPerDay(
    Caravan caravan,
  ) {
    return caravan.leader.waterPerDay +
        caravan.animals.fold<double>(
          0,
          (total, animal) =>
              total +
              AnimalService
                  .waterPerDay(
                animal,
              ),
        );
  }

  static double foragePerDay(
    Caravan caravan,
  ) {
    return caravan.animals.fold<double>(
      0,
      (total, animal) =>
          total +
          AnimalService
              .foragePerDay(
            animal,
          ),
    );
  }

  static bool canTravel(
    Caravan caravan,
  ) {
    return caravan.vehicles.any(
      VehicleService.canPull,
    );
  }

  static bool animalAssigned(
    Caravan caravan,
    Animal animal,
  ) {
    return caravan.vehicles.any(
      (vehicle) =>
          identical(
            vehicle.draftAnimal,
            animal,
          ),
    );
  }

  static void assignAnimal({
    required Vehicle vehicle,
    required Animal animal,
  }) {
    vehicle.draftAnimal = animal;
  }

  static void unassignAnimal(
    Vehicle vehicle,
  ) {
    vehicle.draftAnimal = null;
  }
}