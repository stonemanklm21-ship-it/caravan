import 'animal.dart';
import 'vehicle_type.dart';

class Vehicle {
  final VehicleType type;

  double condition;

  Animal? draftAnimal;

  Vehicle({
    required this.type,
    required this.condition,
    this.draftAnimal,
  });

  bool get operational =>
      condition > 0;

  Map<String, dynamic> toJson() {
    return {
      'type': type.id,
      'condition': condition,
      'draftAnimal':
          draftAnimal?.toJson(),
    };
  }

  factory Vehicle.fromJson({
    required Map<String, dynamic> json,
    required VehicleType Function(
      String id,
    )
    vehicleTypeForId,
    required Animal Function(
      Map<String, dynamic> json,
    )
    animalFromJson,
  }) {
    return Vehicle(
      type: vehicleTypeForId(
        json['type'] as String,
      ),
      condition:
          (json['condition'] as num)
              .toDouble(),
      draftAnimal:
          json['draftAnimal'] == null
              ? null
              : animalFromJson(
                  json['draftAnimal']
                      as Map<String, dynamic>,
                ),
    );
  }
}