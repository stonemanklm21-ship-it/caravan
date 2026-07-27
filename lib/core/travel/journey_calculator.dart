import 'dart:math';

import '../models/caravan.dart';
import '../models/city.dart';
import '../models/journey_info.dart';

class JourneyCalculator {
  static const double mapUnitsPerDay = 250;

  static double distance({
    required double originX,
    required double originY,
    required double destinationX,
    required double destinationY,
  }) {
    final dx = destinationX - originX;
    final dy = destinationY - originY;
    return sqrt(
      (dx * dx) + (dy * dy),
    );
  }

  static double travelHours({
    required double distance,
    required double speed,
  }) {
    final travelDays =
        distance /
        (mapUnitsPerDay * speed);
    return travelDays * 24;
  }

  static JourneyInfo calculate({
    required Caravan caravan,
    required double originX,
    required double originY,
    required City destination,
  }) {
    return calculateToCoordinates(
      caravan: caravan,
      originX: originX,
      originY: originY,
      destinationX: destination.x,
      destinationY: destination.y,
    );
  }

  static JourneyInfo calculateToCoordinates({
    required Caravan caravan,
    required double originX,
    required double originY,
    required double destinationX,
    required double destinationY,
  }) {
    final distanceValue = distance(
      originX: originX,
      originY: originY,
      destinationX: destinationX,
      destinationY: destinationY,
    );

    final travelHoursValue =
        travelHours(
      distance: distanceValue,
      speed: caravan.speed,
    );

    final travelDays =
        travelHoursValue / 24;

    return JourneyInfo(
      distance:                 distanceValue,
      travelHours:              travelHoursValue,
      caloriesRequired:         caravan.calorieRequirementPerDay * travelDays,
      waterRequired:            caravan.waterRequirementPerDay   * travelDays,
      forageRequired:           caravan.forageRequirementPerDay  * travelDays,
      fuelRequired:             caravan.fuelRequirementPerDay    * travelDays,
    );
  }
}