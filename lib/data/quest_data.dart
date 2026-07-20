import '../core/quests/quest_definition.dart';
import '../core/quests/objectives/objective_definition.dart';
import '../core/quests/reward_definition.dart';
import 'character_data.dart';

final visitMiningTownQuest =
    QuestDefinition(
  id: 'visit_miningTown',
  title: 'Visit Mining Town',
  description:
      'Travel to Mining Town.',
  giverId: miningMerchant.id,
  requiresTurnIn: true,
  objectives: [
    ObjectiveDefinition(
      type: 'visit_city',
      params: {
        'cityId': 'miningTown',
      },
    ),
  ],
  rewards: [
    RewardDefinition(
      type: 'gold',
      params: {
        'amount': 100,
      },
    ),
  ],
);