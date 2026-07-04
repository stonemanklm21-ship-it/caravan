import 'dart:math';

import '../models/world.dart';
import '../models/city.dart';
import '../models/player_state.dart';
import '../travel/journey_service.dart';

class DiscoveryService {
  static const double discoveryRadius =
      75;

  static List<City>
      discoverNearbyCities({
    required PlayerState playerState,
    required World world,
  }) {
    final newlyDiscovered = <City>[];

    final currentX =
        JourneyService.currentX(
      playerState,
    );

    final currentY =
        JourneyService.currentY(
      playerState,
    );

    for (final city in world.cities) {
      if (playerState
          .discoveredCities
          .contains(city.id)) {
        continue;
      }

      final dx = city.x - currentX;
      final dy = city.y - currentY;

      final distance = sqrt(
        (dx * dx) + (dy * dy),
      );

      if (distance <=
          discoveryRadius) {
        playerState.discoveredCities.add(
          city.id,
        );

        newlyDiscovered.add(city);
      }
    }

    return newlyDiscovered;
  }
}