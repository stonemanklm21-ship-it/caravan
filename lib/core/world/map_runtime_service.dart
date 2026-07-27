import '../models/player_state.dart';
import '../models/world.dart';
import '../npc/npc_travel_service.dart';
import '../travel/journey_service.dart';
import '../travel/player_follow_service.dart';
import '../travel/travel_service.dart';
import '../world/location_service.dart';
import '../world/visibility_service.dart';

enum MapEventType {
  merchantEncounter,
  banditEncounter,
}

class MapEvent {
  final MapEventType type;

  const MapEvent(this.type);
}

class MapRuntimeService {
  static MapEvent? update({
    required PlayerState player,
    required World world,
    required double tickFraction,
    required double worldTimeHours,
    required double renderedX,
    required double renderedY,
    required double? lastRenderedX,
    required double? lastRenderedY,
  }) {
    PlayerFollowService.update(
      player: player,
      tickFraction: tickFraction,
    );

    if (player.encounteredNpc == null &&
        player.currentCity == null) {
      for (final npc
          in world.npcCaravans) {
        if (player.ignoredNpcs
            .contains(npc)) {
          continue;
        }

        if (npc.activeJourney ==
            null) {
          continue;
        }

        final npcX =
            NpcTravelService
                .currentXSmooth(
          npc: npc,
          worldTimeHours:
              worldTimeHours,
          tickFraction:
              tickFraction,
        );

        final npcY =
            NpcTravelService
                .currentYSmooth(
          npc: npc,
          worldTimeHours:
              worldTimeHours,
          tickFraction:
              tickFraction,
        );

        final distance =
            VisibilityService
                .distance(
          x1: player.smoothX,
          y1: player.smoothY,
          x2: npcX,
          y2: npcY,
        );

        if (distance < 25) {
          player.encounteredNpc =
              npc;

          player.ignoredNpcs.add(
            npc,
          );

          return MapEvent(
            npc.faction.name ==
                    'bandit'
                ? MapEventType
                    .banditEncounter
                : MapEventType
                    .merchantEncounter,
          );
        }
      }
    }

    if (player.activeJourney !=
            null &&
        lastRenderedX != null &&
        lastRenderedY != null) {
      for (final city
          in world.cities) {
        if (city ==
            player.activeJourney!
                .originCity) {
          continue;
        }

        if (LocationService
            .segmentIntersectsCity(
          startX: lastRenderedX,
          startY: lastRenderedY,
          endX: renderedX,
          endY: renderedY,
          city: city,
        )) {
          TravelService.enterCity(
            playerState: player,
            city: city,
          );

          player.followTarget =
              null;

          player.ignoredNpcs.clear();

          JourneyService.clearJourney(
            player,
          );

          break;
        }
      }
    }

    return null;
  }
}