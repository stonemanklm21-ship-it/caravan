import '../core/quests/quest_service.dart';
import 'game_data.dart';
import 'objective_handler_registry_data.dart';
import 'quest_registry_data.dart';
import 'reward_service_data.dart';

final questService = QuestService(
  questRegistry: questRegistry,
  objectiveRegistry:
      objectiveHandlerRegistry,
  rewardService:
      rewardService,
);
