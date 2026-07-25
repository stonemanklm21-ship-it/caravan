import '../../data/game_balance.dart';

import '../combat/combat_strength_service.dart';
import '../models/caravan_faction.dart';
import '../models/city.dart';
import '../models/npc_caravan.dart';
import '../models/world.dart';
import '../world/location_service.dart';
import '../world/visibility_service.dart';
import 'npc_travel_service.dart';

class MerchantThreatService {
  static bool handleThreats({
    required NpcCaravan merchant,
    required World world,
  }) {
    if (merchant.faction !=
        CaravanFaction.merchant) {
      return false;
    }

    // Already fleeing/travelling.
    if (merchant.activeJourney !=
        null) {
      return false;
    }

    NpcCaravan? nearestBandit;

    double nearestDistance =
        double.infinity;

    for (final npc
        in world.npcCaravans) {
      if (npc.faction !=
          CaravanFaction.bandit) {
        continue;
      }

      if (npc.isInSafeZone) {
        continue;
      }

      final distance =
          VisibilityService.distance(
        x1: merchant.x,
        y1: merchant.y,
        x2: npc.x,
        y2: npc.y,
      );

      if (distance >
          GameBalance
              .merchantVisionRange) {
        continue;
      }

      if (distance <
          nearestDistance) {
        nearestDistance =
            distance;

        nearestBandit = npc;
      }
    }

    if (nearestBandit == null) {
      return false;
    }

    final ratio =
        CombatStrengthService
            .strengthRatio(
      attacker:
          nearestBandit.caravan,
      defender: merchant.caravan,
    );

    if (ratio <
        GameBalance
            .merchantFleeRatio) {
      return false;
    }

    final safeCity =
        LocationService.nearestCity(
      world: world,
      x: merchant.x,
      y: merchant.y,
    );

    _fleeToCity(
      merchant: merchant,
      city: safeCity,
    );

    merchant.lastDecision =
        'Fleeing to ${safeCity.name}';

    return true;
  }

  static void _fleeToCity({
    required NpcCaravan merchant,
    required City city,
  }) {
    final currentX =
        NpcTravelService.currentX(
      merchant,
    );

    final currentY =
        NpcTravelService.currentY(
      merchant,
    );

    merchant.worldX = currentX;
    merchant.worldY = currentY;

    merchant.currentCity = null;

    merchant.activeMission = null;

    merchant.followTarget = null;

    merchant.state =
        CaravanState.travelling;

    NpcTravelService.startJourney(
      npc: merchant,
      destination: city,
      originX: currentX,
      originY: currentY,
    );
  }
}