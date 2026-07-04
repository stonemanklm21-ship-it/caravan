import 'vehicle_type.dart';

class Vehicle {
  final VehicleType type;

  double condition;

  Vehicle({
    required this.type,
    required this.condition,
  });

  bool get operational =>
      condition > 0;

  Map<String, dynamic> toJson() {
    return {
      'type': type.id,
      'condition': condition,
    };
  }

  factory Vehicle.fromJson({
    required Map<String, dynamic> json,
    required VehicleType Function(
      String id,
    )
    vehicleTypeForId,
  }) {
    return Vehicle(
      type: vehicleTypeForId(
        json['type'] as String,
      ),
      condition:
          (json['condition'] as num)
              .toDouble(),
    );
  }
}