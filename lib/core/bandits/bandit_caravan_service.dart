import '../models/npc_caravan.dart';
import '../models/player_state.dart';
import '../models/world.dart';
import '../npc/npc_travel_service.dart';
import '../combat/encounter_service.dart';

import 'bandit_pursuit_service.dart';
import 'bandit_roaming_service.dart';
import 'bandit_target_service.dart';

class BanditCaravanService {
  static void changeState(
    NpcCaravan npc,
    CaravanState newState,
    String reason,
  ) {
    print(
      '${npc.hashCode} '
      '${npc.state} -> $newState '
      '($reason)',
    );

    npc.state = newState;
  }

  static void advanceTime({
    required NpcCaravan npc,
    required World world,
    required PlayerState playerState,
    required double hours,
  }) {
    if (EncounterService.isInEncounter(
      npc: npc,
      world: world,
    )) {
      return;
    }

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

          npc.worldX =
              NpcTravelService.currentX(
            npc,
          );

          npc.worldY =
              NpcTravelService.currentY(
            npc,
          );

          npc.activeJourney = null;

          changeState(
            npc,
            CaravanState.pursuing,
            'Target found',
          );

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

          changeState(
            npc,
            CaravanState.roaming,
            'Pursuit ended',
          );
        }

        break;

      default:
        break;
    }
  }
}