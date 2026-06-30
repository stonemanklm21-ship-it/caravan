class Good {
  final String name;

  final double basePrice;
  final double weight;

  final double caloriesPerUnit;

  const Good({
    required this.name,
    required this.basePrice,
    required this.weight,
    this.caloriesPerUnit = 0,
  });
}