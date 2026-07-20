import '../core/models/game.dart';
import '../core/models/player_state.dart';
import '../core/economy/market_ledger.dart';
import '../core/models/caravan.dart';
import '../core/quests/quest_state.dart';


import 'world_data.dart';
import 'cities_data.dart';
import 'character_data.dart';

final game = Game(
  world: world,
  quests: QuestState(
    activeQuests: [],
  ),
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
      leader: defaultPlayer,
      companions: [],
      gold: 100000,
      inventory: [],
      weapons: [],
      armours: [],
      helmets: [],
      animals: [],
      vehicles: [],
      manifest: [],
    ),
  ),
);