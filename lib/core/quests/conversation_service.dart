import '../../data/game_data.dart';
import '../../data/quest_service_data.dart';
import '../events/npc_talked_event.dart';
import '../models/character.dart';

class ConversationService {
  static void talkToNpc({
    required Character npc,
  }) {
    questService.processEvent(
      event: NpcTalkedEvent(
        npcId: npc.id,
      ),
      activeQuests:
          game.quests.activeQuests,
    );
  }
}
