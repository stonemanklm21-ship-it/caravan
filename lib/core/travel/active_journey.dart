import '../models/city.dart';
import '../models/world.dart';

class ActiveJourney {
  final double originX;
  final double originY;

  final City? originCity;

  final double destinationX;
  final double destinationY;

  final City? destinationCity;

  /// Absolute world time when the journey began.
  final double departureHour;

  /// Absolute world time when the journey will end.
  final double arrivalHour;

  ActiveJourney({
    required this.originX,
    required this.originY,
    this.originCity,
    required this.destinationX,
    required this.destinationY,
    this.destinationCity,
    required this.departureHour,
    required this.arrivalHour,
  });

  double progressAt(
    double worldHour,
  ) {
    final duration =
        arrivalHour - departureHour;

    if (duration <= 0) {
      return 1.0;
    }

    return ((worldHour - departureHour) /
            duration)
        .clamp(0.0, 1.0);
  }

  bool completedAt(
    double worldHour,
  ) {
    return worldHour >= arrivalHour;
  }

  double remainingHoursAt(
    double worldHour,
  ) {
    final remaining =
        arrivalHour - worldHour;

    return remaining < 0
        ? 0
        : remaining;
  }

  Map<String, dynamic> toJson() {
    return {
      'originX': originX,
      'originY': originY,
      'originCity': originCity?.id,
      'destinationX': destinationX,
      'destinationY': destinationY,
      'destinationCity':
          destinationCity?.id,
      'departureHour':
          departureHour,
      'arrivalHour':
          arrivalHour,
    };
  }

  factory ActiveJourney.fromJson(
    Map<String, dynamic> json,
    World world,
  ) {
    final originCityId =
        json['originCity']
            as String?;

    final destinationCityId =
        json['destinationCity']
            as String?;

    City? originCity;
    City? destinationCity;

    if (originCityId != null) {
      originCity =
          world.cities.firstWhere(
        (city) =>
            city.id == originCityId,
      );
    }

    if (destinationCityId != null) {
      destinationCity =
          world.cities.firstWhere(
        (city) =>
            city.id ==
            destinationCityId,
      );
    }

    return ActiveJourney(
      originX:
          (json['originX'] as num)
              .toDouble(),
      originY:
          (json['originY'] as num)
              .toDouble(),
      originCity: originCity,
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
      departureHour:
          (json['departureHour']
                  as num)
              .toDouble(),
      arrivalHour:
          (json['arrivalHour']
                  as num)
              .toDouble(),
    );
  }
}