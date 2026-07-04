import '../core/models/game.dart';
import '../core/models/player_state.dart';
import '../core/economy/market_ledger.dart';
import '../core/models/caravan.dart';
import '../core/models/caravan_component_stack.dart';

import 'world_data.dart';
import 'cities_data.dart';
import 'caravan_components_data.dart';

final game = Game(
  world: world,
  player: PlayerState(
    worldTimeHours: 1,
    currentCity: farmingVillage,
    worldX: farmingVillage.x,
    worldY: farmingVillage.y,
    discoveredCities: {
      farmingVillage.id,
    },
    ledger: MarketLedger(),
    caravan: Caravan(
      gold: 100,
      inventory: [],
      components: [
        CaravanComponentStack(
          component: player,
          quantity: 1,
        ),
      ],
    ),
  ),
);