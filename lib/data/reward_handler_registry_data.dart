import '../core/quests/rewards/gold_reward_handler.dart';
import '../core/quests/rewards/reward_handler_registry.dart';

final rewardHandlerRegistry =
    RewardHandlerRegistry(
  handlers: {
    'gold': GoldRewardHandler(),
  },
);