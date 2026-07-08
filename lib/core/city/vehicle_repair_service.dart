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

  static void repair(
    Vehicle vehicle,
  ) {
    vehicle.condition =
        vehicle.type.maxCondition;
  }
}
