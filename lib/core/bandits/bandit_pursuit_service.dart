import '../../data/game_balance.dart';

import '../combat/encounter_service.dart';
import '../models/caravan_faction.dart';
import '../models/npc_caravan.dart';
import '../models/world.dart';
import '../world/visibility_service.dart';
import '../npc/npc_travel_service.dart';

import 'bandit_city_service.dart';

class BanditPursuitService {
  static const double captureRange =
      25;

  static bool handlePursuit({
    required NpcCaravan npc,
    required World world,
    required double worldTimeHours,
    required double hours,
    required double tickFraction,
  }) {
    for (final other
        in world.npcCaravans) {
      if (other == npc) {
        continue;
      }

      if (other.faction !=
          CaravanFaction.merchant) {
        continue;
      }

      if (other
              .surrenderProtectionHours >
          0) {
        continue;
      }

      final nearbyDistance =
          VisibilityService.distance(
        x1: npc.x,
        y1: npc.y,
        x2: other.x,
        y2: other.y,
      );

      if (nearbyDistance <=
          captureRange) {
        EncounterService
            .tryStartEncounter(
          bandit: npc,
          merchant: other,
          world: world,
          worldTimeHours:
              worldTimeHours,
        );

        npc.followTarget = null;

        return false;
      }
    }

    final target =
        npc.followTarget;

    if (target == null) {
      return false;
    }

    final targetX =
        target.smoothX;

    final targetY =
        target.smoothY;

    if (BanditCityService
        .isInsideSafeZone(
      x: targetX,
      y: targetY,
      world: world,
    )) {
      npc.followTarget = null;

      return false;
    }

    final distance =
        VisibilityService.distance(
      x1: npc.x,
      y1: npc.y,
      x2: targetX,
      y2: targetY,
    );

    if (distance >
        GameBalance
                .banditVisionRange *
            1.2) {
      npc.followTarget = null;

      return false;
    }

    if (distance <=
        captureRange) {
      if (target is NpcCaravan) {
        if (target
                .surrenderProtectionHours >
            0) {
          npc.followTarget = null;

          return false;
        }

        EncounterService
            .tryStartEncounter(
          bandit: npc,
          merchant: target,
          world: world,
          worldTimeHours:
              worldTimeHours,
        );
      }

      npc.followTarget = null;

      return false;
    }

    if (npc.activeJourney == null) {
      NpcTravelService
          .startJourneyToCoordinates(
        npc: npc,
        worldTimeHours:
            worldTimeHours,
        destinationX:
            targetX,
        destinationY:
            targetY,
        originX:
            NpcTravelService
                .currentXSmooth(
          npc: npc,
          worldTimeHours:
              worldTimeHours,
          tickFraction:
              tickFraction,
        ),
        originY:
            NpcTravelService
                .currentYSmooth(
          npc: npc,
          worldTimeHours:
              worldTimeHours,
          tickFraction:
              tickFraction,
        ),
      );
    }

    return true;
  }
}