import '../models/animal.dart';
import '../models/caravan.dart';
import '../models/character.dart';
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
      (total, vehicle) {
        final capacity =
            VehicleService
                    .cargoCapacityKg(
                  vehicle,
                ) -
                passengerWeight(
                  caravan,
                  vehicle,
                );

        return total +
            capacity.clamp(
              0.0,
              double.infinity,
            );
      },
    );

    final leaderCapacity =
        caravan.leader.mounted
            ? 0
            : caravan
                .leader
                .cargoCapacityKg;

    final companionCapacity =
        caravan.companions.fold<double>(
      0,
      (total, companion) {
        if (companion.mounted) {
          return total;
        }

        return total +
            companion
                .cargoCapacityKg;
      },
    );

    final animalCapacity =
        caravan.animals.fold<double>(
      0,
      (total, animal) {
        if (animalAssigned(
          caravan,
          animal,
        )) {
          return total;
        }

        final capacity =
            AnimalService
                    .cargoCapacityKg(
                  animal,
                ) -
                riderWeight(
                  caravan,
                  animal,
                );

        return total +
            capacity.clamp(
              0.0,
              double.infinity,
            );
      },
    );

    return leaderCapacity +
        companionCapacity +
        animalCapacity +
        vehicleCapacity;
  }

  static double waterPerDay(
    Caravan caravan,
  ) {
    final companionWater =
        caravan.companions.fold<double>(
      0,
      (total, companion) =>
          total +
          companion.waterPerDay,
    );

    final animalWater =
        caravan.animals.fold<double>(
      0,
      (total, animal) =>
          total +
          AnimalService
              .waterPerDay(
            animal,
          ),
    );

    return caravan.leader.waterPerDay +
        companionWater +
        animalWater;
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
    if (caravan.vehicles.isEmpty) {
      return true;
    }

    return caravan.vehicles.every(
      VehicleService.canPull,
    );
  }

  static bool animalAssigned(
    Caravan caravan,
    Animal animal,
  ) {
    return caravan.vehicles.any(
      (vehicle) => identical(
        vehicle.draftAnimal,
        animal,
      ),
    );
  }

  static Character? riderOf(
    Caravan caravan,
    Animal animal,
  ) {
    if (identical(
      caravan.leader.mountedAnimal,
      animal,
    )) {
      return caravan.leader;
    }

    for (final companion
        in caravan.companions) {
      if (identical(
        companion.mountedAnimal,
        animal,
      )) {
        return companion;
      }
    }

    return null;
  }

  static double riderWeight(
    Caravan caravan,
    Animal animal,
  ) {
    final rider = riderOf(
      caravan,
      animal,
    );

    return rider?.weightKg ?? 0;
  }

  static bool animalHasRider(
    Caravan caravan,
    Animal animal,
  ) {
    return riderOf(
          caravan,
          animal,
        ) !=
        null;
  }

  static bool canMountAnimal({
    required Caravan caravan,
    required Character character,
    required Animal animal,
  }) {
    if (!animal.alive) {
      return false;
    }

    if (animalAssigned(
      caravan,
      animal,
    )) {
      return false;
    }

    if (animalHasRider(
      caravan,
      animal,
    )) {
      return false;
    }

    return AnimalService.canCarryRider(
      animal: animal,
      character: character,
    );
  }

  static List<Character> passengersOf(
    Caravan caravan,
    Vehicle vehicle,
  ) {
    final passengers =
        <Character>[];

    if (identical(
      caravan.leader.mountedVehicle,
      vehicle,
    )) {
      passengers.add(
        caravan.leader,
      );
    }

    for (final companion
        in caravan.companions) {
      if (identical(
        companion.mountedVehicle,
        vehicle,
      )) {
        passengers.add(
          companion,
        );
      }
    }

    return passengers;
  }

  static double passengerWeight(
    Caravan caravan,
    Vehicle vehicle,
  ) {
    return passengersOf(
      caravan,
      vehicle,
    ).fold(
      0.0,
      (total, passenger) =>
          total +
          passenger.weightKg,
    );
  }

  static bool canMountVehicle({
    required Vehicle vehicle,
  }) {
    return VehicleService
        .canPull(vehicle);
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