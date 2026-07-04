import '../core/models/vehicle_type.dart';

const cart = VehicleType(
  id: 'cart',
  name: 'Cart',
  maxCondition: 100,
  capacityMultiplier: 3,
  maxCargoKg: 150,
);

const vehicleTypes = [
  cart,
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