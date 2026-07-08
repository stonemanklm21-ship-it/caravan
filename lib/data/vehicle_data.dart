import '../core/models/vehicle_type.dart';

const smallCart = VehicleType(
  id: 'small_cart',
  name: 'Small Cart',
  maxCondition: 100,
  capacityMultiplier: 2,
  maxCargoKg: 150,
  requiredPullingCapacityKg: 20,
  basePrice: 5000,
);

const cart = VehicleType(
  id: 'cart',
  name: 'Cart',
  maxCondition: 100,
  capacityMultiplier: 3,
  maxCargoKg: 500,
  requiredPullingCapacityKg: 60,
  basePrice: 10000,
);

const largeCart = VehicleType(
  id: 'large_cart',
  name: 'Large Cart',
  maxCondition: 100,
  capacityMultiplier: 4,
  maxCargoKg: 800,
  requiredPullingCapacityKg: 150,
  basePrice: 20000,
);

const vehicleTypes = [
  smallCart,
  cart,
  largeCart,
];

final vehicleTypesById = {
  for (final vehicle in vehicleTypes)
    vehicle.id: vehicle,
};

VehicleType vehicleTypeForId(
  String id,
) {
  return vehicleTypesById[id]!;
}