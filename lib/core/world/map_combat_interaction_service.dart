import '../models/npc_caravan.dart';
import '../models/world.dart';

class MapCombatInteractionService {
  static void removeDefeatedNpc({
    required World world,
    required NpcCaravan npc,
  }) {
    world.npcCaravans.remove(
      npc,
    );
  }
}