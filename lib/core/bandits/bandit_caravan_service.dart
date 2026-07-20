import '../models/npc_caravan.dart';
import '../models/player_state.dart';
import '../models/world.dart';
import '../npc/npc_travel_service.dart';
import '../world/visibility_service.dart';

import 'bandit_pursuit_service.dart';
import 'bandit_roaming_service.dart';
import 'bandit_target_service.dart';

class BanditCaravanService {
  static void advanceTime({
    required NpcCaravan npc,
    required World world,
    required PlayerState playerState,
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
          playerState: playerState,
        );

        if (target != null) {
          npc.followTarget = target;

          npc.state =
              CaravanState.pursuing;

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
        final currentTarget =
            npc.followTarget;

        final betterTarget =
            BanditTargetService
                .findTarget(
          bandit: npc,
          world: world,
          playerState: playerState,
        );

        if (currentTarget != null &&
            betterTarget != null &&
            betterTarget !=
                currentTarget) {
          final currentDistance =
              VisibilityService.distance(
            x1: NpcTravelService
                .currentX(npc),
            y1: NpcTravelService
                .currentY(npc),
            x2: currentTarget.x,
            y2: currentTarget.y,
          );

          final newDistance =
              VisibilityService.distance(
            x1: NpcTravelService
                .currentX(npc),
            y1: NpcTravelService
                .currentY(npc),
            x2: betterTarget.x,
            y2: betterTarget.y,
          );

          if (newDistance <
              currentDistance * 0.5) {
            npc.followTarget =
                betterTarget;
          }
        }

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