import '../models/vehicle.dart';

class VehicleRepairService {
  static double repairCost(
    Vehicle vehicle,
  ) {
    return (vehicle.type.maxCondition -
            vehicle.condition) *
        10;
  }

  static bool canRepair(
    Vehicle vehicle,
  ) {
    return vehicle.condition <
        vehicle.type.maxCondition;
  }

  static double repairAllCost(
    Iterable<Vehicle> vehicles,
  ) {
    return vehicles.fold(
      0,
      (total, vehicle) =>
          total + repairCost(vehicle),
    );
  }

  static bool canRepairAny(
    Iterable<Vehicle> vehicles,
  ) {
    return vehicles.any(
      canRepair,
    );
  }

  static void repair(
    Vehicle vehicle,
  ) {
    vehicle.condition =
        vehicle.type.maxCondition;
  }

  static void repairAll(
    Iterable<Vehicle> vehicles,
  ) {
    for (final vehicle
        in vehicles) {
      repair(vehicle);
    }
  }
}