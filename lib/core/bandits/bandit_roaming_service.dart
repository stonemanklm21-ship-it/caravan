import 'dart:math';

import '../models/npc_caravan.dart';
import '../models/world.dart';
import '../npc/npc_travel_service.dart';
import '../world/location_service.dart';
import '../world/region_service.dart';

class BanditRoamingService {
  static final Random _random =
      Random();

  static void startRoaming({
    required NpcCaravan npc,
    required World world,
  }) {
    final region =
        npc.homeRegion;

    if (region == null) {
      return;
    }

    final centreX =
        RegionService.centreX(
      region: region,
      world: world,
    );

    final centreY =
        RegionService.centreY(
      region: region,
      world: world,
    );

    final radius =
        RegionService.radius(
      region: region,
      world: world,
    );

    for (int i = 0; i < 10; i++) {
      final angle =
          _random.nextDouble() *
              pi *
              2;

      final distance =
          _random.nextDouble() *
              radius;

      final destinationX =
          centreX +
          (cos(angle) * distance);

      final destinationY =
          centreY +
          (sin(angle) * distance);

      bool routeIntersectsCity =
          false;

      for (final city
          in world.cities) {
        if (LocationService
            .segmentIntersectsCity(
startX: NpcTravelService.currentX(npc),
startY: NpcTravelService.currentY(npc),
          endX: destinationX,
          endY: destinationY,
          city: city,
        )) {
          routeIntersectsCity =
              true;
          break;
        }
      }

      if (routeIntersectsCity) {
        continue;
      }

      NpcTravelService
          .startJourneyToCoordinates(
        npc: npc,
        destinationX:
            destinationX,
        destinationY:
            destinationY,
      );

      return;
    }
  }
}