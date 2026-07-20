import '../core/quests/rewards/reward_service.dart';
import 'reward_handler_registry_data.dart';

final rewardService = RewardService(
  rewardRegistry:
      rewardHandlerRegistry,
);