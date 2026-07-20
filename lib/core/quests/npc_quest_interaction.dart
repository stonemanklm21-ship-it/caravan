import 'npc_quest_state.dart';
import 'quest_service.dart';
import '../models/game.dart';


class NpcQuestInteraction {
  final QuestService questService;

  NpcQuestInteraction({
    required this.questService,
  });

  NpcQuestState getState({
    required String npcId,
    required Game game,
  }) {
    return questService.getNpcQuestState(
      npcId: npcId,
      activeQuests:
          game.quests.activeQuests,
    );
  }
}
