import 'dart:math';

import '../models/caravan.dart';
import '../models/city.dart';
import '../models/journey_info.dart';

class JourneyCalculator {
  static const double mapUnitsPerDay = 500;

  static JourneyInfo calculate({
    required Caravan caravan,
    required double originX,
    required double originY,
    required City destination,
  }) {
    final dx = destination.x - originX;
    final dy = destination.y - originY;

    final distance = sqrt(
      (dx * dx) + (dy * dy),
    );

    final travelDays =
        distance /
        (mapUnitsPerDay * caravan.speed);

    final travelHours = travelDays * 24;

    return JourneyInfo(
      distance: distance,
      travelHours: travelHours,
      caloriesRequired:
          caravan.calorieRequirementPerDay *
          travelDays,
      waterRequired:
          caravan.waterRequirementPerDay *
          travelDays,
      forageRequired:
          caravan.forageRequirementPerDay *
          travelDays,
      fuelRequired:
          caravan.fuelRequirementPerDay *
          travelDays,
    );
  }
}