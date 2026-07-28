import 'dart:ui';

import '../combat/encounter_service.dart';
import '../models/caravan_faction.dart';
import '../models/npc_caravan.dart';
import '../models/player_state.dart';
import '../models/world.dart';
import '../npc/npc_travel_service.dart';
import '../travel/journey_service.dart';
import '../world/visibility_service.dart';

import 'map_snapshot.dart';

class MapSnapshotService {
  static MapSnapshot build({
    required PlayerState player,
    required World world,
    required double tickFraction,
    NpcCaravan? selectedNpcCaravan,
  }) {
    final playerX =
        JourneyService.currentXSmooth(
      player,
      tickFraction,
    );

    final playerY =
        JourneyService.currentYSmooth(
      player,
      tickFraction,
    );

    final npcPositions =
        <NpcCaravan, Offset>{};

    final visibleNpcs =
        <NpcCaravan>[];

    for (final npc
        in world.npcCaravans) {
      if (npc == selectedNpcCaravan) {
        final journey =
            npc.activeJourney;

        print(
          'SNAPSHOT '
          'world=${player.worldTimeHours} '
          'tick=$tickFraction '
          'origin=${journey?.originX} '
          'departure=${journey?.departureHour} '
          'arrival=${journey?.arrivalHour}',
        );
      }

      final encounter =
          EncounterService
              .encounterForNpc(
        npc: npc,
        world: world,
      );

      if (encounter != null) {
        npcPositions[npc] = Offset(
          encounter.bandit == npc
              ? encounter.banditX
              : encounter.merchantX,
          encounter.bandit == npc
              ? encounter.banditY
              : encounter.merchantY,
        );
      } else {
        npcPositions[npc] = Offset(
          NpcTravelService
              .currentXSmooth(
            npc: npc,
            worldTimeHours:
                player.worldTimeHours,
            tickFraction:
                tickFraction,
          ),
          NpcTravelService
              .currentYSmooth(
            npc: npc,
            worldTimeHours:
                player.worldTimeHours,
            tickFraction:
                tickFraction,
          ),
        );
      }

if (npc.currentCity != null &&
    npc.faction !=
        CaravanFaction.bandit) {


  continue;
}

      if (VisibilityService.canSee(
        observerX: playerX,
        observerY: playerY,
        targetX:
            npcPositions[npc]!.dx,
        targetY:
            npcPositions[npc]!.dy,
        range: VisibilityService
            .caravanVisionRange(
          player.caravan.scoutSkill,
        ),
      )) {
        visibleNpcs.add(npc);
      }
    }

    final playerTravelling =
        player.activeJourney != null;

    final npcTravelling =
        world.npcCaravans.any(
      (npc) =>
          npc.activeJourney != null,
    );

    return MapSnapshot(
      playerX: playerX,
      playerY: playerY,
      npcPositions:
          npcPositions,
      visibleNpcs:
          visibleNpcs,
      playerTravelling:
          playerTravelling,
      npcTravelling:
          npcTravelling,
    );
  }
}