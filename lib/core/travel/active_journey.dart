import '../models/city.dart';
import '../models/world.dart';

class ActiveJourney {
  double originX;
  double originY;

  final double destinationX;
  final double destinationY;

  final City? destinationCity;

  final double totalHours;

  double elapsedHours;

  double tickFractionOffset;

  ActiveJourney({
    required this.originX,
    required this.originY,
    required this.destinationX,
    required this.destinationY,
    this.destinationCity,
    required this.totalHours,
    this.elapsedHours = 0,
    this.tickFractionOffset = 0,
  });

  double get progress {
    if (totalHours <= 0) {
      return 1;
    }

    return elapsedHours / totalHours;
  }

  bool get completed {
    return elapsedHours >= totalHours;
  }

  double get remainingHours {
    return totalHours - elapsedHours;
  }

  Map<String, dynamic> toJson() {
    return {
      'originX': originX,
      'originY': originY,
      'destinationX': destinationX,
      'destinationY': destinationY,
      'destinationCity':
          destinationCity?.id,
      'totalHours': totalHours,
      'elapsedHours': elapsedHours,
      'tickFractionOffset':
          tickFractionOffset,
    };
  }

  factory ActiveJourney.fromJson(
    Map<String, dynamic> json,
    World world,
  ) {
    final cityId =
        json['destinationCity']
            as String?;

    City? destinationCity;

    if (cityId != null) {
      destinationCity =
          world.cities.firstWhere(
        (city) =>
            city.id == cityId,
      );
    }

    return ActiveJourney(
      originX:
          (json['originX'] as num)
              .toDouble(),
      originY:
          (json['originY'] as num)
              .toDouble(),
      destinationX:
          (json['destinationX']
                  as num)
              .toDouble(),
      destinationY:
          (json['destinationY']
                  as num)
              .toDouble(),
      destinationCity:
          destinationCity,
      totalHours:
          (json['totalHours']
                  as num)
              .toDouble(),
      elapsedHours:
          (json['elapsedHours']
                  as num)
              .toDouble(),
      tickFractionOffset:
          (json['tickFractionOffset']
                      as num?)
                  ?.toDouble() ??
              0.0,
    );
  }
}