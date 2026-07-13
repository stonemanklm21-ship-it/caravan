class Weapon {
  final String id;
  final String name;

  final int accuracy;
  final int damageDie;

  final double weightKg;

  final double basePrice;

  const Weapon({
    required this.id,
    required this.name,
    required this.accuracy,
    required this.damageDie,
    required this.weightKg,
    required this.basePrice,
  });
}