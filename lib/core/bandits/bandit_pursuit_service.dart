import '../models/npc_caravan.dart';
import '../models/world.dart';
import '../npc/npc_travel_service.dart';
import '../world/visibility_service.dart';

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
      x2:
          NpcTravelService.currentX(
        target,
      ),
      y2:
          NpcTravelService.currentY(
        target,
      ),
    );

    if (distance <=
        captureRange) {
      world.caravansToRemove.add(
        target,
      );

      npc.followTarget = null;

      print(
        'Merchant captured',
      );

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