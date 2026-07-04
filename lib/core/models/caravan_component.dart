enum CaravanComponentType {
  person,
  packAnimal,
  vehicle,
  guard,
}

class CaravanComponent {
  final String id;
  final String name;

  final CaravanComponentType type;

  /// Additional carrying capacity provided by this component.
  final double cargoCapacityKg;

  /// Caravan moves at the speed of its slowest component.
  final double travelSpeed;

  /// Purchase cost in gold.
  final double purchasePrice;

  /// Human food requirement in kcal per day.
  final double caloriesPerDay;

  /// Water requirement in litres/units per day.
  final double waterPerDay;

  /// Animal feed requirement in units per day.
  final double foragePerDay;

  /// Fuel requirement in units per day.
  final double fuelPerDay;

  const CaravanComponent({
    required this.id,
    required this.name,
    required this.type,
    required this.cargoCapacityKg,
    required this.travelSpeed,
    required this.purchasePrice,
    required this.caloriesPerDay,
    required this.waterPerDay,
    required this.foragePerDay,
    required this.fuelPerDay,
  });
}