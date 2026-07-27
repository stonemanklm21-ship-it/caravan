import '../models/npc_caravan.dart';
import '../models/player_state.dart';

class MapEncounterInteractionService {
  static void dismissEncounter({
    required PlayerState player,
  }) {
    player.encounteredNpc = null;
  }

  static void ignoreEncounter({
    required PlayerState player,
    required NpcCaravan npc,
  }) {
    player.ignoredNpcs.add(npc);
    player.encounteredNpc = null;
  }

  static void prepareCombat({
    required PlayerState player,
  }) {
    player.encounteredNpc = null;
  }
}