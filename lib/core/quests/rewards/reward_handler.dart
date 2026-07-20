// lib/core/quests/rewards/reward_handler.dart

import '../../models/game.dart';
import '../reward_definition.dart';

abstract class RewardHandler {
  void grant({
    required Game game,
    required RewardDefinition reward,
  });
}