import 'dart:math';

import '../models/city.dart';
import '../models/world.dart';

class LocationService {
  static const double cityRadius = 15;

  static City? cityAtPosition({
    required World world,
    required double x,
    required double y,
  }) {
    for (final city in world.cities) {
      final dx = city.x - x;
      final dy = city.y - y;

      final distance = sqrt(
        (dx * dx) + (dy * dy),
      );

      if (distance <= cityRadius) {
        return city;
      }
    }

    return null;
  }

  static bool segmentIntersectsCity({
    required double startX,
    required double startY,
    required double endX,
    required double endY,
    required City city,
  }) {
    print('CITY HIT: ${city.name}');
    final dx = endX - startX;
    final dy = endY - startY;

    final startDistance = sqrt(
      (startX - city.x) *
              (startX - city.x) +
          (startY - city.y) *
              (startY - city.y),
    );

    // Ignore the city we're leaving.
    if (startDistance <= cityRadius) {
      return false;
    }

    final fx = startX - city.x;
    final fy = startY - city.y;

    final a = dx * dx + dy * dy;

    if (a == 0) {
      return false;
    }

    final b =
        2 * ((fx * dx) + (fy * dy));

    final c =
        (fx * fx) +
        (fy * fy) -
        (cityRadius *
            cityRadius);

    final discriminant =
        (b * b) - (4 * a * c);

    if (discriminant < 0) {
      return false;
    }

    final root =
        sqrt(discriminant);

    final t1 =
        (-b - root) / (2 * a);

    final t2 =
        (-b + root) / (2 * a);

    return (t1 >= 0 && t1 <= 1) ||
        (t2 >= 0 && t2 <= 1);
  }
}