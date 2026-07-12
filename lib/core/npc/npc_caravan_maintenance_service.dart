import '../city/vehicle_repair_service.dart';
import '../models/npc_caravan.dart';

class NpcCaravanMaintenanceService {
  static void repairVehicles({
    required NpcCaravan npc,
  }) {
    final city = npc.currentCity;

    if (city == null || !city.hasCartwright) {
      return;
    }

    for (final vehicle in npc.caravan.vehicles) {
      final cost =
          VehicleRepairService.repairCost(
        vehicle,
      );

      if (npc.caravan.gold >= cost) {
        npc.caravan.gold -= cost;

        VehicleRepairService.repair(
          vehicle,
        );
      }
    }
  }
}