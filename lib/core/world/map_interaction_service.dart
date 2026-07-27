import '../models/npc_caravan.dart';
import '../models/player_state.dart';

class MapInteractionService {
  static void clearFollowTarget({
    required PlayerState player,
  }) {
    player.followTarget = null;
  }

  static void followNpc({
    required PlayerState player,
    required NpcCaravan npc,
  }) {
    player.followTarget = npc;
  }
}