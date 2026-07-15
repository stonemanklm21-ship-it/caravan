import 'dart:math';

import '../../data/caravan_templates.dart';

import '../city/recruitment_service.dart';
import '../economy/market_ledger.dart';
import '../models/caravan.dart';
import '../models/caravan_faction.dart';
import '../models/city.dart';
import '../models/npc_caravan.dart';

class BanditCaravanGenerator {
  static final Random _random =
      Random();

  static List<NpcCaravan> generate({
    required List<City> cities,
    required int merchantCount,
  }) {
    final banditCount = max(
      1,
      merchantCount ~/ 5,
    );

    return List.generate(
      banditCount,
      (_) {
        final city =
            cities[_random.nextInt(
          cities.length,
        )];

        final template =
            caravanTemplates[
                _random.nextInt(
          caravanTemplates.length,
        )];

        return NpcCaravan(
          worldX: city.x,
          worldY: city.y,
          currentCity: city,
          homeRegion: city.region,
          caravan:
              _buildBanditCaravan(
            template,
          ),
          faction:
              CaravanFaction.bandit,
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
    CaravanTemplate template,
  ) {
    final leader =
        RecruitmentService
            .generateRecruit(
              tier:
                  RecruitmentMarketTier
                      .major,
            )
            .character;

    final companions =
        List.generate(
      template.companions,
      (_) =>
          RecruitmentService
              .generateRecruit(
                tier:
                    RecruitmentMarketTier
                        .major,
              )
              .character,
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