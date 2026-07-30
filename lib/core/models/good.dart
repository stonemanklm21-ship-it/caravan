class Good {
  final String id;
  final String variableName;

  final String name;

  final double priceFloor;
  final double priceCeiling;

  final double weight;

  final double caloriesPerUnit;
  final double waterPerUnit;

  final double populationDemandPerPersonPerDay;

  const Good({
    required this.id,
    required this.variableName,
    required this.name,
    required this.priceFloor,
    required this.priceCeiling,
    required this.weight,
    this.caloriesPerUnit = 0,
    this.waterPerUnit = 0,
    this.populationDemandPerPersonPerDay = 0,
  });
}