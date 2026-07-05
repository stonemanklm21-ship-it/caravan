class VehicleType {
  final String id;

  final String name;

  final double maxCondition;

  final double capacityMultiplier;

  final double maxCargoKg;

  final double requiredPullingCapacityKg;

  final double basePrice;

  const VehicleType({
    required this.id,
    required this.name,
    required this.maxCondition,
    required this.capacityMultiplier,
    required this.maxCargoKg,
    required this.requiredPullingCapacityKg,
    required this.basePrice,
  });
}