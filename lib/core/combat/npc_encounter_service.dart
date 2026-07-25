import '../../data/game_balance.dart';

import '../combat/combat_strength_service.dart';
import '../models/npc_caravan.dart';
import '../models/world.dart';
import '../npc/npc_travel_service.dart';

class NpcEncounterService {
  static void resolveBanditVsMerchant({
    required NpcCaravan bandit,
    required NpcCaravan merchant,
    required World world,
  }) {
    final ratio =
        CombatStrengthService
            .strengthRatio(
      attacker: bandit.caravan,
      defender: merchant.caravan,
    );

    if (ratio >=
        GameBalance.surrenderRatio) {
      final tribute =
          merchant.caravan.gold * 0.2;

      merchant.caravan.gold -=
          tribute;

      bandit.caravan.gold +=
          tribute;

      // Preserve current position
      // before cancelling travel.
      merchant.worldX =
          NpcTravelService.currentX(
        merchant,
      );

      merchant.worldY =
          NpcTravelService.currentY(
        merchant,
      );

      merchant.activeJourney = null;

      merchant
          .surrenderProtectionHours =
          24;

      merchant.activeMission = null;

      merchant.state =
          CaravanState.recovering;

      merchant.idleHoursRemaining =
          12;

      merchant.lastDecision =
          'Paid tribute to bandits';

      bandit.lastDecision =
          'Robbed merchant';

      return;
    }

    final banditStrength =
        CombatStrengthService
            .caravanStrength(
      bandit.caravan,
    );

    final merchantStrength =
        CombatStrengthService
            .caravanStrength(
      merchant.caravan,
    );

    if (banditStrength >=
        merchantStrength) {
      world.caravansToRemove.add(
        merchant,
      );

      bandit.lastDecision =
          'Defeated merchant';
    } else {
      world.caravansToRemove.add(
        bandit,
      );

      merchant.lastDecision =
          'Defeated bandits';
    }
  }
}