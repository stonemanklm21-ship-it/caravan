import '../../data/game_balance.dart';

import '../combat/combat_strength_service.dart';
import '../models/caravan_faction.dart';
import '../models/npc_caravan.dart';
import '../models/player_state.dart';
import '../models/world.dart';
import '../npc/npc_travel_service.dart';
import '../world/visibility_service.dart';

import 'bandit_city_service.dart';
import 'bandit_target.dart';

class BanditTargetService {
  static BanditTarget? findTarget({
    required NpcCaravan bandit,
    required World world,
    required PlayerState playerState,
  }) {
    BanditTarget? nearestTarget;

    double nearestDistance =
        double.infinity;

    final banditX =
        NpcTravelService.currentX(
      npc: bandit,
      worldTimeHours:
          playerState.worldTimeHours,
    );

    final banditY =
        NpcTravelService.currentY(
      npc: bandit,
      worldTimeHours:
          playerState.worldTimeHours,
    );

    // Merchants
    for (final other
        in world.npcCaravans) {
      if (other == bandit) {
        continue;
      }

      if (other
              .surrenderProtectionHours >
          0) {
        continue;
      }

      if (other.faction !=
          CaravanFaction.merchant) {
        continue;
      }

      final merchantX =
          NpcTravelService.currentX(
        npc: other,
        worldTimeHours:
            playerState.worldTimeHours,
      );

      final merchantY =
          NpcTravelService.currentY(
        npc: other,
        worldTimeHours:
            playerState.worldTimeHours,
      );

      if (BanditCityService
          .isInsideSafeZone(
        x: merchantX,
        y: merchantY,
        world: world,
      )) {
        continue;
      }

      final distance =
          VisibilityService.distance(
        x1: banditX,
        y1: banditY,
        x2: merchantX,
        y2: merchantY,
      );

      if (distance >
          GameBalance
              .banditVisionRange) {
        continue;
      }

      final ratio =
          CombatStrengthService
              .strengthRatio(
        attacker: bandit.caravan,
        defender: other.caravan,
      );

      if (ratio <
          GameBalance
              .banditAttackRatio) {
        continue;
      }

      if (distance <
          nearestDistance) {
        nearestDistance =
            distance;

        nearestTarget =
            other;
      }
    }

  // Player
if (!playerState.isInSafeZone &&
    playerState.banditProtectionHours <=
        0) {

      final playerDistance =
          VisibilityService.distance(
        x1: banditX,
        y1: banditY,
        x2: playerState.x,
        y2: playerState.y,
      );

      final ratio =
          CombatStrengthService
              .strengthRatio(
        attacker: bandit.caravan,
        defender: playerState.caravan,
      );

      if (playerDistance <=
              GameBalance
                  .banditVisionRange &&
          playerDistance <
              nearestDistance &&
          ratio >=
              GameBalance
                  .banditAttackRatio) {
        nearestDistance =
            playerDistance;

        nearestTarget =
            playerState;
      }
    }

    return nearestTarget;
  }
}