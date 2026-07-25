import '../combat/npc_encounter_service.dart';
import '../models/active_encounter.dart';
import '../models/npc_caravan.dart';
import '../models/world.dart';
import '../npc/npc_travel_service.dart';

class EncounterService {
  static bool isInEncounter({
    required NpcCaravan npc,
    required World world,
  }) {
    return world.activeEncounters.any(
      (encounter) =>
          encounter.bandit == npc ||
          encounter.merchant == npc,
    );
  }

  static bool tryStartEncounter({
    required NpcCaravan bandit,
    required NpcCaravan merchant,
    required World world,
  }) {
    final alreadyInEncounter =
        world.activeEncounters.any(
      (encounter) =>
          encounter.bandit == bandit ||
          encounter.merchant ==
              merchant,
    );

    if (alreadyInEncounter) {
      return false;
    }

    // Freeze both caravans at their
    // current rendered position.
    final banditX =
        NpcTravelService.currentXSmooth(
      bandit,
      0,
    );

    final banditY =
        NpcTravelService.currentYSmooth(
      bandit,
      0,
    );

    final merchantX =
        NpcTravelService.currentXSmooth(
      merchant,
      0,
    );

    final merchantY =
        NpcTravelService.currentYSmooth(
      merchant,
      0,
    );

    bandit.worldX = banditX;
    bandit.worldY = banditY;

    merchant.worldX = merchantX;
    merchant.worldY = merchantY;

    bandit.activeJourney = null;
    merchant.activeJourney = null;

    world.activeEncounters.add(
      ActiveEncounter(
        bandit: bandit,
        merchant: merchant,
        banditX: banditX,
        banditY: banditY,
        merchantX: merchantX,
        merchantY: merchantY,
      ),
    );

    return true;
  }

  static ActiveEncounter?
      encounterForNpc({
    required NpcCaravan npc,
    required World world,
  }) {
    for (final encounter
        in world.activeEncounters) {
      if (encounter.bandit == npc ||
          encounter.merchant == npc) {
        return encounter;
      }
    }

    return null;
  }

  static void advance({
    required World world,
    required double hours,
  }) {
    final completed =
        <ActiveEncounter>[];

    for (final encounter
        in world.activeEncounters) {
      encounter.hoursRemaining -=
          hours;

      if (encounter.hoursRemaining >
          0) {
        continue;
      }

      encounter.bandit.worldX =
          encounter.banditX;

      encounter.bandit.worldY =
          encounter.banditY;

      encounter.merchant.worldX =
          encounter.merchantX;

      encounter.merchant.worldY =
          encounter.merchantY;

      NpcEncounterService
          .resolveBanditVsMerchant(
        bandit: encounter.bandit,
        merchant:
            encounter.merchant,
        world: world,
      );

      completed.add(encounter);
    }

    world.activeEncounters.removeWhere(
      completed.contains,
    );
  }
}