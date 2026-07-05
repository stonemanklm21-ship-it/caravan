class Character {
  final String id;

  String name;

  int ageYears;

  final double cargoCapacityKg;

  final double caloriesPerDay;

  final double waterPerDay;

  final double wagePerDay;

  double hp;

  final double maxHp;

  Character({
    required this.id,
    required this.name,
    required this.ageYears,
    required this.cargoCapacityKg,
    required this.caloriesPerDay,
    required this.waterPerDay,
    required this.wagePerDay,
    required this.hp,
    required this.maxHp,
  });

  bool get alive => hp > 0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ageYears': ageYears,
      'cargoCapacityKg': cargoCapacityKg,
      'caloriesPerDay': caloriesPerDay,
      'waterPerDay': waterPerDay,
      'wagePerDay': wagePerDay,
      'hp': hp,
      'maxHp': maxHp,
    };
  }

  factory Character.fromJson(
    Map<String, dynamic> json,
  ) {
    return Character(
      id: json['id'] as String,
      name: json['name'] as String,
      ageYears: json['ageYears'] as int,
      cargoCapacityKg:
          (json['cargoCapacityKg'] as num)
              .toDouble(),
      caloriesPerDay:
          (json['caloriesPerDay'] as num)
              .toDouble(),
      waterPerDay:
          (json['waterPerDay'] as num)
              .toDouble(),
      wagePerDay:
          (json['wagePerDay'] as num)
              .toDouble(),
      hp:
          (json['hp'] as num)
              .toDouble(),
      maxHp:
          (json['maxHp'] as num)
              .toDouble(),
    );
  }
}