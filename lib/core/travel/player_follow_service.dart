import '../models/player_state.dart';
import '../npc/npc_travel_service.dart';
import 'journey_service.dart';

class PlayerFollowService {
  static void update({
    required PlayerState player,
    required double tickFraction,
  }) {
    final target =
        player.followTarget;

    if (target == null) {
      return;
    }

    if (target.currentCity != null) {
      player.followTarget = null;
      return;
    }

    JourneyService.startJourneyToCoordinates(
      playerState: player,
      destinationX:
          NpcTravelService.currentX(
        target,
      ),
      destinationY:
          NpcTravelService.currentY(
        target,
      ),
      originX:
          JourneyService.currentXSmooth(
        player,
        tickFraction,
      ),
      originY:
          JourneyService.currentYSmooth(
        player,
        tickFraction,
      ),
      tickFractionOffset:
          tickFraction,
    );
  }

  static void stopFollowing(
    PlayerState player,
  ) {
    player.followTarget = null;
  }
}