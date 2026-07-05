import 'dart:math';

import '../../data/vehicle_data.dart';
import '../models/vehicle.dart';
import '../models/vehicle_type.dart';

enum VehicleMarketTier {
  basic,
  regional,
  major,
}

class VehicleMarketService {
  static final Random _random =
      Random();

  static List<VehicleType>
      availableVehicles(
    VehicleMarketTier tier,
  ) {
    switch (tier) {
      case VehicleMarketTier.basic:
        return [
          smallCart,
        ];

      case VehicleMarketTier.regional:
        return [
          smallCart,
          cart,
        ];

      case VehicleMarketTier.major:
        return [
          smallCart,
          cart,
          largeCart,
        ];
    }
  }

  static List<Vehicle> generateStock({
    required VehicleMarketTier tier,
    required int stockSize,
  }) {
    final types =
        availableVehicles(tier);

    return List.generate(
      stockSize,
      (index) => generateVehicle(
        types[
            index %
                types.length],
      ),
    );
  }

  static Vehicle generateVehicle(
    VehicleType type,
  ) {
    return Vehicle(
      type: type,
      condition:
          type.maxCondition *
          (0.7 +
              (_random.nextDouble() *
                  0.3)),
    );
  }

  static double price(
    Vehicle vehicle,
  ) {
    return vehicle.type.basePrice *
        (vehicle.condition /
            vehicle.type.maxCondition);
  }
}