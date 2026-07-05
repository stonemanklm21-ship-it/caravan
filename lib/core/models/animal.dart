import 'animal_type.dart';

enum AnimalGender {
  male,
  female,
}

class Animal {
  final AnimalType type;

  AnimalGender gender;

  double hp;

  double ageYears;

  double adultWeightKg;

  Animal({
    required this.type,
    required this.gender,
    required this.hp,
    required this.ageYears,
    required this.adultWeightKg,
  });

  bool get alive => hp > 0;

  Map<String, dynamic> toJson() {
    return {
      'type': type.id,
      'gender': gender.name,
      'hp': hp,
      'ageYears': ageYears,
      'adultWeightKg': adultWeightKg,
    };
  }

  factory Animal.fromJson({
    required Map<String, dynamic> json,
    required AnimalType Function(
      String id,
    )
    animalTypeForId,
  }) {
    return Animal(
      type: animalTypeForId(
        json['type'] as String,
      ),
      gender:
          AnimalGender.values.firstWhere(
        (gender) =>
            gender.name ==
            json['gender'],
      ),
      hp:
          (json['hp'] as num)
              .toDouble(),
      ageYears:
          (json['ageYears'] as num)
              .toDouble(),
      adultWeightKg:
          (json['adultWeightKg'] as num)
              .toDouble(),
    );
  }
}