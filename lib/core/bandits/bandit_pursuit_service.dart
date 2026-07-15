import '../models/npc_caravan.dart';
import '../models/world.dart';
import '../npc/npc_travel_service.dart';

class BanditPursuitService {
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

    if (npc.activeJourney != null) {
      return false;
    }

    print('Starting pursuit');

    NpcTravelService
        .startJourneyToCoordinates(
      npc: npc,
      destinationX:
          NpcTravelService.currentX(
        target,
      ),
      destinationY:
          NpcTravelService.currentY(
        target,
      ),
    );

    return false;
  }
}
