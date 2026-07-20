import '../models/caravan_faction.dart';
import '../models/npc_caravan.dart';
import '../models/player_state.dart';
import '../models/world.dart';
import '../npc/npc_travel_service.dart';
import '../world/visibility_service.dart';

import 'bandit_city_service.dart';
import 'bandit_target.dart';

class BanditTargetService {
  static BanditTarget? findTarget({
    required NpcCaravan bandit,
    required World world,
    required PlayerState playerState,
  }) {
    BanditTarget? nearestTarget;

    double nearestDistance =
        double.infinity;

    // Merchants
    for (final other
        in world.npcCaravans) {
      if (other == bandit) {
        continue;
      }

      if (other.faction !=
          CaravanFaction.merchant) {
        continue;
      }

      if (other.isInSafeZone) {
        continue;
      }

      final distance =
          VisibilityService.distance(
        x1: bandit.x,
        y1: bandit.y,
        x2: other.x,
        y2: other.y,
      );

      if (distance >
          VisibilityService
              .banditVisionRange) {
        continue;
      }

      if (distance <
          nearestDistance) {
        nearestDistance =
            distance;

        nearestTarget =
            other;
      }
    }

    // Player
    if (!playerState.isInSafeZone) {
      final playerDistance =
          VisibilityService.distance(
        x1: bandit.x,
        y1: bandit.y,
        x2: playerState.x,
        y2: playerState.y,
      );

      if (playerDistance <=
              VisibilityService
                  .banditVisionRange &&
          playerDistance <
              nearestDistance) {
        nearestDistance =
            playerDistance;

        nearestTarget =
            playerState;
      }
    }

    return nearestTarget;
  }
}