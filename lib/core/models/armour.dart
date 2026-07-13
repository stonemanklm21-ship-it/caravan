class Armour {
  final String id;
  final String name;

  /// Makes you harder to hit.
  final int protection;

  /// Counts against caravan cargo capacity.
  final double weightKg;

     final double basePrice;


  const Armour({
    required this.id,
    required this.name,
    required this.protection,
    required this.weightKg,
    required this.basePrice,

  });
}