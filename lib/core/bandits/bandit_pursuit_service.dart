import '../models/npc_caravan.dart';
import '../models/world.dart';
import '../npc/npc_travel_service.dart';
import '../world/visibility_service.dart';

import 'bandit_city_service.dart';

class BanditPursuitService {
  static const double captureRange =
      25;

  static bool handlePursuit({
    required NpcCaravan npc,
    required World world,
    required double hours,
  }) {
    final target =
        npc.followTarget;

    if (target == null) {
      return false;
    }

    final targetX =
        NpcTravelService.currentX(
      target,
    );

    final targetY =
        NpcTravelService.currentY(
      target,
    );

    if (BanditCityService
        .isInsideSafeZone(
      x: targetX,
      y: targetY,
      world: world,
    )) {
      npc.followTarget = null;

      return false;
    }

    final distance =
        VisibilityService.distance(
      x1:
          NpcTravelService.currentX(
        npc,
      ),
      y1:
          NpcTravelService.currentY(
        npc,
      ),
      x2: targetX,
      y2: targetY,
    );

    if (distance >
        VisibilityService
                .banditVisionRange *
            1.2) {
      npc.followTarget = null;

      return false;
    }

    if (distance <=
        captureRange) {
      world.caravansToRemove.add(
        target,
      );

      npc.followTarget = null;

      return false;
    }

    NpcTravelService
        .startJourneyToCoordinates(
      npc: npc,
      destinationX: targetX,
      destinationY: targetY,
      originX:
          NpcTravelService.currentX(
        npc,
      ),
      originY:
          NpcTravelService.currentY(
        npc,
      ),
    );

    return true;
  }
}