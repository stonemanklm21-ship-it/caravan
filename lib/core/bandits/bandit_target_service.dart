import '../models/caravan_faction.dart';
import '../models/npc_caravan.dart';
import '../models/world.dart';
import '../npc/npc_travel_service.dart';
import '../world/visibility_service.dart';

class BanditTargetService {
  static NpcCaravan? findTarget({
    required NpcCaravan bandit,
    required World world,
  }) {
    NpcCaravan? nearestMerchant;

    double nearestDistance =
        double.infinity;

    for (final other
        in world.npcCaravans) {
      if (other == bandit) {
        continue;
      }

      if (other.faction !=
          CaravanFaction.merchant) {
        continue;
      }

      final distance =
          VisibilityService.distance(
        x1:
            NpcTravelService.currentX(
          bandit,
        ),
        y1:
            NpcTravelService.currentY(
          bandit,
        ),
        x2:
            NpcTravelService.currentX(
          other,
        ),
        y2:
            NpcTravelService.currentY(
          other,
        ),
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

        nearestMerchant =
            other;
      }
    }

    return nearestMerchant;
  }
}