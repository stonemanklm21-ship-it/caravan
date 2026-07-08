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

  final double speed;

  int doctorSkill;

  int vetSkill;

  int mechanicSkill;

  int scoutSkill;

  int combatSkill;

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
    required this.speed,
    this.doctorSkill = 0,
    this.vetSkill = 0,
    this.mechanicSkill = 0,
    this.scoutSkill = 0,
    this.combatSkill = 0,
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
      'speed': speed,
      'doctorSkill': doctorSkill,
      'vetSkill': vetSkill,
      'mechanicSkill': mechanicSkill,
      'scoutSkill': scoutSkill,
      'combatSkill': combatSkill,
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
      speed:
          (json['speed'] as num)
              .toDouble(),
      doctorSkill:
          json['doctorSkill'] as int? ?? 0,
      vetSkill:
          json['vetSkill'] as int? ?? 0,
      mechanicSkill:
          json['mechanicSkill'] as int? ?? 0,
      scoutSkill:
          json['scoutSkill'] as int? ?? 0,
      combatSkill:
          json['combatSkill'] as int? ?? 0,
    );
  }
}