import 'dart:math';

import '../models/debug_npc_tracker.dart';
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
    required double worldTimeHours,
    required double tickFraction,
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

    final departureHour =
        worldTimeHours +
        tickFraction;

    for (int i = 0; i < 50; i++) {
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

      final currentX =
          NpcTravelService
              .currentXSmooth(
        npc: npc,
        worldTimeHours:
            worldTimeHours,
        tickFraction:
            tickFraction,
      );

      final currentY =
          NpcTravelService
              .currentYSmooth(
        npc: npc,
        worldTimeHours:
            worldTimeHours,
        tickFraction:
            tickFraction,
      );

      for (final city
          in world.cities) {
        if (LocationService
            .segmentIntersectsCity(
          startX: currentX,
          startY: currentY,
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

      DebugNpcTracker
              .trackedNpcHashCode =
          npc.hashCode;

      NpcTravelService
          .startJourneyToCoordinates(
        npc: npc,
        worldTimeHours:
            worldTimeHours,
        departureHour:
            departureHour,
        destinationX:
            destinationX,
        destinationY:
            destinationY,
        originX: currentX,
        originY: currentY,
      );
      return;
    }
  }
}