import '../../models/game.dart';
import '../reward_definition.dart';
import 'reward_handler.dart';

class GoldRewardHandler
    implements RewardHandler {

  GoldRewardHandler();

  @override
  void grant({
    required Game game,
    required RewardDefinition reward,
  }) {
    final amount =
        reward.params['amount'] as num;

    game.player.caravan.gold +=
        amount.toDouble();
  }
}