class Good {
  final String id;
  final String name;

  final double priceFloor;
  final double priceCeiling;

  final double weight;

  final double caloriesPerUnit;
  final double waterPerUnit;

  const Good({
    required this.id,
    required this.name,
    required this.priceFloor,
    required this.priceCeiling,
    required this.weight,
    this.caloriesPerUnit = 0,
    this.waterPerUnit = 0,
  });
}