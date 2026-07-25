import '../../data/game_balance.dart';

import '../combat/combat_strength_service.dart';
import '../models/caravan_faction.dart';
import '../models/npc_caravan.dart';
import '../models/player_state.dart';
import '../models/world.dart';
import '../world/visibility_service.dart';

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

    // Merchants
    for (final other
        in world.npcCaravans) {
      if (other == bandit) {
        continue;
      }

      if (other
              .surrenderProtectionHours >
          0) {
        print(
          'Skip merchant: protection '
          '${other.surrenderProtectionHours}',
        );
        continue;
      }

      if (other.faction !=
          CaravanFaction.merchant) {
        continue;
      }

      final distance =
          VisibilityService.distance(
        x1: bandit.x,
        y1: bandit.y,
        x2: other.x,
        y2: other.y,
      );

      if (distance >
          GameBalance
              .banditVisionRange) {
        continue;
      }

      CombatStrengthService
          .debugCaravan(
        name: 'Bandit',
        caravan: bandit.caravan,
      );

      CombatStrengthService
          .debugCaravan(
        name: 'Merchant',
        caravan: other.caravan,
      );

      final ratio =
          CombatStrengthService
              .strengthRatio(
        attacker: bandit.caravan,
        defender: other.caravan,
      );

      print(
        'Bandit vs merchant ratio '
        '${ratio.toStringAsFixed(2)}',
      );

      if (ratio <
          GameBalance
              .banditAttackRatio) {
        print(
          'Skip merchant: ratio too low',
        );
        continue;
      }

      if (distance <
          nearestDistance) {
        print(
          'TARGET ACQUIRED',
        );

        nearestDistance =
            distance;

        nearestTarget =
            other;
      }
    }

    // Player
    if (!playerState.isInSafeZone) {
      final playerDistance =
          VisibilityService.distance(
        x1: bandit.x,
        y1: bandit.y,
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
        print(
          'PLAYER TARGET ACQUIRED',
        );

        nearestDistance =
            playerDistance;

        nearestTarget =
            playerState;
      }
    }

    return nearestTarget;
  }
}