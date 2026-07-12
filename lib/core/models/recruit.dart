import 'animal.dart';
import 'character.dart';
import 'vehicle.dart';

class Recruit {
  final Character character;

  final double hiringCost;

  Recruit({
    required this.character,
    required this.hiringCost,
  });

  Map<String, dynamic> toJson() {
    return {
      'character':
          character.toJson(),
      'hiringCost':
          hiringCost,
    };
  }

  factory Recruit.fromJson({
    required Map<String, dynamic>
        json,
    required Animal Function(
      Map<String, dynamic> json,
    )
    animalFromJson,
    required Vehicle Function(
      Map<String, dynamic> json,
    )
    vehicleFromJson,
  }) {
    return Recruit(
      character:
          Character.fromJson(
        json['character']
            as Map<String, dynamic>,
        animalFromJson:
            animalFromJson,
        vehicleFromJson:
            vehicleFromJson,
      ),
      hiringCost:
          (json['hiringCost']
                  as num)
              .toDouble(),
    );
  }
}
