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
    required double worldTimeHours,
    required double tickFraction,
  }) {
    if (merchant.faction !=
        CaravanFaction.merchant) {
      return false;
    }

    if (merchant.currentCity != null) {
      return false;
    }

    if (merchant.state ==
        CaravanState.fleeing) {
      return false;
    }

    if (merchant.state ==
        CaravanState.recovering) {
      return false;
    }

    final merchantX =
        NpcTravelService.currentX(
      npc: merchant,
      worldTimeHours:
          worldTimeHours,
    );

    final merchantY =
        NpcTravelService.currentY(
      npc: merchant,
      worldTimeHours:
          worldTimeHours,
    );

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

      final banditX =
          NpcTravelService.currentX(
        npc: npc,
        worldTimeHours:
            worldTimeHours,
      );

      final banditY =
          NpcTravelService.currentY(
        npc: npc,
        worldTimeHours:
            worldTimeHours,
      );

      final distance =
          VisibilityService.distance(
        x1: merchantX,
        y1: merchantY,
        x2: banditX,
        y2: banditY,
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
      x: merchantX,
      y: merchantY,
    );

    _fleeToCity(
      merchant: merchant,
      city: safeCity,
      worldTimeHours:
          worldTimeHours,
      tickFraction:
          tickFraction,
    );

    merchant.lastDecision =
        'Fleeing to ${safeCity.name}';

    return true;
  }

  static void _fleeToCity({
    required NpcCaravan merchant,
    required City city,
    required double worldTimeHours,
    required double tickFraction,
  }) {
    final fleeX =
        NpcTravelService
            .currentXSmooth(
      npc: merchant,
      worldTimeHours:
          worldTimeHours,
      tickFraction:
          tickFraction,
    );

    final fleeY =
        NpcTravelService
            .currentYSmooth(
      npc: merchant,
      worldTimeHours:
          worldTimeHours,
      tickFraction:
          tickFraction,
    );

    merchant.activeJourney = null;

    merchant.currentCity = null;

    merchant.activeMission = null;

    merchant.followTarget = null;

    merchant.state =
        CaravanState.fleeing;

    NpcTravelService.startJourney(
      npc: merchant,
      destination: city,
      worldTimeHours:
          worldTimeHours,
      originX: fleeX,
      originY: fleeY,
    );
  }
}