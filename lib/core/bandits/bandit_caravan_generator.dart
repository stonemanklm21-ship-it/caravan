import 'dart:math';

import '../../data/game_balance.dart';

import '../../data/bandit_faction_data.dart';

import '../bandits/bandit_equipment_service.dart';
import '../bandits/bandit_recruitment_service.dart';
import '../economy/market_ledger.dart';
import '../models/bandit_faction.dart';
import '../models/caravan.dart';
import '../models/caravan_faction.dart';
import '../models/city.dart';
import '../models/npc_caravan.dart';

class BanditCaravanGenerator {
  static final Random _random = Random();

  static List<NpcCaravan> generate({
    required List<City> cities,
    required int merchantCount,
  }) {
    final banditCount = max(
      1,
      merchantCount ~/ GameBalance.merchantsPerBandit,
    );

    return List.generate(
      banditCount,
      (_) {
        final city =
            cities[_random.nextInt(
          cities.length,
        )];

        final banditFaction =
            banditFactionForRegion(
          city.region,
        );

        final angle =
            _random.nextDouble() *
                pi *
                2;

        final distance =
            GameBalance.banditMinSpawnDistance +
            (_random.nextDouble() *
                GameBalance.banditMaxSpawnDistance);

        final spawnX =
            city.x +
            cos(angle) * distance;

        final spawnY =
            city.y +
            sin(angle) * distance;

        return NpcCaravan(
          worldX: spawnX,
          worldY: spawnY,
          currentCity: null,
          homeRegion: city.region,
          caravan:
              _buildBanditCaravan(
            banditFaction,
          ),
          faction:
              CaravanFaction.bandit,
          banditFaction:
              banditFaction,
          ledger: MarketLedger(
            observations: [],
          ),
          state:
              CaravanState.roaming,
        );
      },
    );
  }

  static Caravan _buildBanditCaravan(
    BanditFaction faction,
  ) {
    final leader =
        BanditRecruitmentService
            .generateBandit(
      faction: faction,
    );

    BanditEquipmentService
        .equipBandit(
      character: leader,
      faction: faction,
      leader: true,
    );

    final companionCount =
        _random.nextInt(
      faction.maxCompanions + 1,
    );

    final companions =
        List.generate(
      companionCount,
      (_) {
        final character =
            BanditRecruitmentService
                .generateBandit(
          faction: faction,
        );

        BanditEquipmentService
            .equipBandit(
          character: character,
          faction: faction,
          leader: false,
        );

        return character;
      },
    );

    return Caravan(
      leader: leader,
      companions: companions,
      gold:
          50 +
          (_random.nextDouble() *
              200),
      inventory: [],
      weapons: [],
      armours: [],
      helmets: [],
      animals: [],
      vehicles: [],
      manifest: [],
    );
  }
}