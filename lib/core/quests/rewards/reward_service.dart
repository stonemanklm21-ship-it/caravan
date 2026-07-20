import '../../models/game.dart';
import '../reward_definition.dart';
import 'reward_handler_registry.dart';

class RewardService {
  final RewardHandlerRegistry
      rewardRegistry;

  RewardService({
    required this.rewardRegistry,
  });

  void grantRewards({
    required Game game,
    required List<RewardDefinition>
        rewards,
  }) {
    for (final reward in rewards) {
      final handler =
          rewardRegistry.get(
        reward.type,
      );

      if (handler == null) {
        continue;
      }

      handler.grant(
        game: game,
        reward: reward,
      );
    }
  }
}