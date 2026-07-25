import '../../data/game_balance.dart';

import '../combat/npc_encounter_service.dart';
import '../models/caravan_faction.dart';
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
    // Opportunistic encounters:
    // rob any merchant already in range.
    for (final other
        in world.npcCaravans) {
      if (other == npc) {
        continue;
      }

      if (other.faction !=
          CaravanFaction.merchant) {
        continue;
      }

      final nearbyDistance =
          VisibilityService.distance(
        x1: npc.x,
        y1: npc.y,
        x2: other.x,
        y2: other.y,
      );

      if (nearbyDistance <=
          captureRange) {
        NpcEncounterService
            .resolveBanditVsMerchant(
          bandit: npc,
          merchant: other,
          world: world,
        );

        npc.followTarget = null;

        return false;
      }
    }

    final target =
        npc.followTarget;

    if (target == null) {
      return false;
    }

    final targetX =
        target.smoothX;

    final targetY =
        target.smoothY;

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
        GameBalance
                .banditVisionRange *
            1.2) {
      npc.followTarget = null;

      return false;
    }

    if (distance <=
        captureRange) {
      if (target is NpcCaravan) {
        NpcEncounterService
            .resolveBanditVsMerchant(
          bandit: npc,
          merchant: target,
          world: world,
        );
      }

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