import '../../data/game_balance.dart';

import '../combat/encounter_service.dart';
import '../models/npc_caravan.dart';
import '../models/player_state.dart';
import '../models/world.dart';
import '../npc/npc_travel_service.dart';
import '../world/visibility_service.dart';

class BanditPursuitService {
  static const double captureRange = 25;

  static bool update({
    required NpcCaravan bandit,
    required World world,
    required double worldTimeHours,
    required double tickFraction,
  }) {
    final target = bandit.followTarget;

    if (target == null) {
      return false;
    }

    if (target is! NpcCaravan &&
        target is! PlayerState) {
      bandit.followTarget = null;
      return false;
    }

    final targetX =
        target is NpcCaravan
            ? NpcTravelService.currentX(
                npc: target,
                worldTimeHours:
                    worldTimeHours,
              )
            : target.x;

    final targetY =
        target is NpcCaravan
            ? NpcTravelService.currentY(
                npc: target,
                worldTimeHours:
                    worldTimeHours,
              )
            : target.y;

    final banditX =
        NpcTravelService.currentX(
      npc: bandit,
      worldTimeHours:
          worldTimeHours,
    );

    final banditY =
        NpcTravelService.currentY(
      npc: bandit,
      worldTimeHours:
          worldTimeHours,
    );

    final distance =
        VisibilityService.distance(
      x1: banditX,
      y1: banditY,
      x2: targetX,
      y2: targetY,
    );

    if (distance >
        GameBalance.banditVisionRange *
            1.2) {
      bandit.followTarget = null;
      return false;
    }

    if (distance <= captureRange) {
      if (target is NpcCaravan) {
        EncounterService
            .tryStartEncounter(
          bandit: bandit,
          merchant: target,
          world: world,
          worldTimeHours:
              worldTimeHours,
        );
      } else if (target
          is PlayerState) {
        target.encounteredNpc =
            bandit;
        target.ignoredNpcs.add(
          bandit,
        );
      }

      bandit.followTarget = null;

      return true;
    }

    NpcTravelService
        .startJourneyToCoordinates(
      npc: bandit,
      worldTimeHours:
          worldTimeHours,
      departureHour:
          worldTimeHours +
          tickFraction,
      destinationX: targetX,
      destinationY: targetY,
      originX: banditX,
      originY: banditY,
    );

    return true;
  }
}