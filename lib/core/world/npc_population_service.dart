import 'dart:math';

import '../models/caravan_faction.dart';
import '../models/world.dart';
import '../bandits/bandit_caravan_generator.dart';
import '../npc/npc_caravan_generator.dart';

class NpcPopulationService {
  static int targetMerchantCount(
    World world,
  ) {
    return world.cities.fold(
      0,
      (sum, city) =>
          sum +
          max(
            1,
            city.population ~/ 1000,
          ),
    );
  }

  static int targetBanditCount(
    World world,
  ) {
    return max(
      1,
      targetMerchantCount(
            world,
          ) ~/
          5,
    );
  }

  static int currentMerchantCount(
    World world,
  ) {
    return world.npcCaravans
        .where(
          (npc) =>
              npc.faction ==
              CaravanFaction.merchant,
        )
        .length;
  }

  static int currentBanditCount(
    World world,
  ) {
    return world.npcCaravans
        .where(
          (npc) =>
              npc.faction ==
              CaravanFaction.bandit,
        )
        .length;
  }

  static int merchantDeficit(
    World world,
  ) {
    return max(
      0,
      targetMerchantCount(
            world,
          ) -
          currentMerchantCount(
            world,
          ),
    );
  }

  static int banditDeficit(
    World world,
  ) {
    return max(
      0,
      targetBanditCount(
            world,
          ) -
          currentBanditCount(
            world,
          ),
    );
  }

  static void maintain(
    World world,
  ) {
    final missingMerchants =
        merchantDeficit(world);

    if (missingMerchants > 0) {
      world.npcCaravans.addAll(
        NpcCaravanGenerator.generate(
          cities: world.cities,
        ).take(
          missingMerchants,
        ),
      );
    }

    final missingBandits =
        banditDeficit(world);

    if (missingBandits > 0) {
      world.npcCaravans.addAll(
        BanditCaravanGenerator.generate(
          cities: world.cities,
          merchantCount:
              targetMerchantCount(
            world,
          ),
        ).take(
          missingBandits,
        ),
      );
    }
  }
}