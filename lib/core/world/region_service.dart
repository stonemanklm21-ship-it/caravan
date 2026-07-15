import 'dart:math';

import '../models/city.dart';
import '../models/region.dart';
import '../models/world.dart';

class RegionService {
  static List<City> citiesInRegion({
    required Region region,
    required World world,
  }) {
    return world.cities
        .where(
          (city) =>
              city.region.id ==
              region.id,
        )
        .toList();
  }

  static double centreX({
    required Region region,
    required World world,
  }) {
    final cities =
        citiesInRegion(
      region: region,
      world: world,
    );

    return cities
            .map((c) => c.x)
            .reduce((a, b) => a + b) /
        cities.length;
  }

  static double centreY({
    required Region region,
    required World world,
  }) {
    final cities =
        citiesInRegion(
      region: region,
      world: world,
    );

    return cities
            .map((c) => c.y)
            .reduce((a, b) => a + b) /
        cities.length;
  }

  static double radius({
    required Region region,
    required World world,
    double buffer = 100,
  }) {
    final centreXValue =
        centreX(
      region: region,
      world: world,
    );

    final centreYValue =
        centreY(
      region: region,
      world: world,
    );

    final cities =
        citiesInRegion(
      region: region,
      world: world,
    );

    double furthest = 0;

    for (final city in cities) {
      final dx =
          city.x - centreXValue;

      final dy =
          city.y - centreYValue;

      final distance =
          sqrt(
        (dx * dx) +
            (dy * dy),
      );

      if (distance > furthest) {
        furthest = distance;
      }
    }

    return furthest + buffer;
  }
}