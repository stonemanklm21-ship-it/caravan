import 'dart:math';
import '../models/world.dart';
import '../models/city.dart';

class LocationService {
  static const double cityRadius = 30;

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
}