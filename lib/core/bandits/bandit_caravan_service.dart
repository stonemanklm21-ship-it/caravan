import '../models/npc_caravan.dart';
import '../models/world.dart';
import '../npc/npc_travel_service.dart';

import 'bandit_pursuit_service.dart';
import 'bandit_roaming_service.dart';
import 'bandit_target_service.dart';

class BanditCaravanService {
  static void advanceTime({
    required NpcCaravan npc,
    required World world,
    required double hours,
  }) {
    if (npc.activeJourney != null) {
      NpcTravelService.advanceJourney(
        npc: npc,
        hours: hours,
      );

      if (!npc.activeJourney!
          .completed) {
        return;
      }

      NpcTravelService.arrive(
        npc: npc,
      );
    }

    final target =
        BanditTargetService
            .findTarget(
      bandit: npc,
      world: world,
    );

    if (target != null &&
        npc.followTarget == null) {
      print('Target acquired');

      npc.followTarget = target;
    }

    BanditPursuitService
        .handlePursuit(
      npc: npc,
      world: world,
      hours: hours,
    );

    if (npc.activeJourney == null) {
      BanditRoamingService
          .startRoaming(
        npc: npc,
        world: world,
      );
    }
  }
}