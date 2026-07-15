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

      if (npc.activeJourney!
          .completed) {
        NpcTravelService.arrive(
          npc: npc,
        );
      }
    }

    switch (npc.state) {
      case CaravanState.roaming:
        final target =
            BanditTargetService
                .findTarget(
          bandit: npc,
          world: world,
        );

        if (target != null) {
          npc.followTarget = target;

          npc.state =
              CaravanState.pursuing;

          // Start pursuit immediately so
          // we don't spend a tick in a
          // pursuing state with no journey.
          BanditPursuitService
              .handlePursuit(
            npc: npc,
            world: world,
            hours: hours,
          );

          break;
        }

        if (npc.activeJourney ==
            null) {
          BanditRoamingService
              .startRoaming(
            npc: npc,
            world: world,
          );
        }

        break;

      case CaravanState.pursuing:
        final pursuing =
            BanditPursuitService
                .handlePursuit(
          npc: npc,
          world: world,
          hours: hours,
        );

        if (!pursuing) {
          npc.followTarget = null;

          npc.state =
              CaravanState.roaming;
        }

        break;

      default:
        break;
    }
  }
}