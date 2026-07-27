import '../models/npc_caravan.dart';
import '../models/player_state.dart';
import '../models/world.dart';
import '../models/debug_npc_tracker.dart';
import '../npc/npc_travel_service.dart';
import '../combat/encounter_service.dart';

import 'bandit_roaming_service.dart';

class BanditCaravanService {
  static void changeState(
    NpcCaravan npc,
    CaravanState newState,
    String reason,
  ) {
    npc.state = newState;
  }

  static void advanceTime({
    required NpcCaravan npc,
    required World world,
    required PlayerState playerState,
    required double hours,
    required double tickFraction,
  }) {
    if (EncounterService.isInEncounter(
      npc: npc,
      world: world,
    )) {
      return;
    }

    if (npc.hashCode ==
        DebugNpcTracker.trackedNpcHashCode) {
      final complete =
          NpcTravelService.isComplete(
        npc: npc,
        worldTimeHours:
            playerState.worldTimeHours +
            tickFraction,
      );

    }

    if (npc.activeJourney != null &&
        NpcTravelService.isComplete(
          npc: npc,
          worldTimeHours:
              playerState.worldTimeHours +
              tickFraction,
        )) {
      NpcTravelService.arrive(
        npc: npc,
      );
    }

    if (npc.activeJourney == null) {
      BanditRoamingService
          .startRoaming(
        npc: npc,
        world: world,
        worldTimeHours:
            playerState
                .worldTimeHours,
        tickFraction:
            tickFraction,
      );
    }
  }
}
