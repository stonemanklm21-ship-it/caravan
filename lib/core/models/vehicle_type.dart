class VehicleType {
  final String id;

  final String name;

  final double maxCondition;

  final double capacityMultiplier;

  final double maxCargoKg;

  const VehicleType({
    required this.id,
    required this.name,
    required this.maxCondition,
    required this.capacityMultiplier,
    required this.maxCargoKg,
  });
}