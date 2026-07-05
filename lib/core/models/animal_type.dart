class AnimalType {
  final String id;

  final String name;

  final double maxHp;

  final double lifeExpectancyYears;

  final double averageAdultWeightKg;

  final double speed;

  final double basePrice;

  const AnimalType({
    required this.id,
    required this.name,
    required this.maxHp,
    required this.lifeExpectancyYears,
    required this.averageAdultWeightKg,
    required this.speed,
    required this.basePrice,
  });
}