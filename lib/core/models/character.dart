class Character {
  final String id;

  String name;

  final double cargoCapacityKg;

  final double caloriesPerDay;

  final double waterPerDay;

  double hp;

  final double maxHp;

  Character({
    required this.id,
    required this.name,
    required this.cargoCapacityKg,
    required this.caloriesPerDay,
    required this.waterPerDay,
    required this.hp,
    required this.maxHp,
  });

  bool get alive => hp > 0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cargoCapacityKg': cargoCapacityKg,
      'caloriesPerDay': caloriesPerDay,
      'waterPerDay': waterPerDay,
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
      cargoCapacityKg:
          (json['cargoCapacityKg'] as num)
              .toDouble(),
      caloriesPerDay:
          (json['caloriesPerDay'] as num)
              .toDouble(),
      waterPerDay:
          (json['waterPerDay'] as num)
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