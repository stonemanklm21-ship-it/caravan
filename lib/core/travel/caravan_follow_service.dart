import '../models/npc_caravan.dart';
import '../npc/npc_travel_service.dart';

class CaravanFollowService {
  static void startFollowing({
    required NpcCaravan follower,
    required NpcCaravan target,
  }) {
    follower.followTarget = target;
  }

  static void stopFollowing({
    required NpcCaravan follower,
  }) {
    follower.followTarget = null;
  }

  static bool isFollowing(
    NpcCaravan npc,
  ) {
    return npc.followTarget != null;
  }

  static void updateFollowing({
    required NpcCaravan follower,
  }) {
    final target =
        follower.followTarget;

    if (target == null) {
      return;
    }

    follower.worldX =
        NpcTravelService.currentX(
      target,
    );

    follower.worldY =
        NpcTravelService.currentY(
      target,
    );
  }
}