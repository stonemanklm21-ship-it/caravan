import 'dart:math';

import '../economy/market_ledger.dart';
import '../models/caravan.dart';
import '../models/caravan_component_stack.dart';
import '../models/city.dart';
import '../models/npc_caravan.dart';
import '../../data/caravan_components_data.dart';

class NpcCaravanGenerator {
  static final Random _random =
      Random();

  static List<NpcCaravan> generate({
    required List<City> cities,
  }) {
    final caravans = <NpcCaravan>[];

    for (final city in cities) {
      final traderCount =
          max(
        1,
        city.population ~/ 1000,
      );

      for (
        int i = 0;
        i < traderCount;
        i++
      ) {
        caravans.add(
          NpcCaravan(
            worldX: city.x,
            worldY: city.y,
            currentCity: city,
            caravan: Caravan(
              gold:
                  (200 +
                          _random.nextInt(
                            301,
                          ))
                      .toDouble(),
              inventory: [],
              components: [
                CaravanComponentStack(
                  component: person,
                  quantity: 3,
                ),
              ],
            ),
            ledger: MarketLedger(
              observations: [],
            ),
          ),
        );
      }
    }

    return caravans;
  }
}