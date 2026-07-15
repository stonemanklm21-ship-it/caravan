import 'dart:math';

import '../models/world.dart';

class BanditCityService {
  static const double cityExclusionRadius =
      50;

static bool isInsideSafeZone({
  required double x,
  required double y,
  required World world,
}) {
  for (final city in world.cities) {
    final dx = x - city.x;
    final dy = y - city.y;

    final distance = sqrt(
      (dx * dx) +
      (dy * dy),
    );

    if (distance <=
        cityExclusionRadius) {

      return true;
    }
  }

  return false;
}
}