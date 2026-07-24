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

  availableText:
      'Could you travel to Mining Town for me?',

  activeText:
      'Please come back once you have visited Mining Town.',

  readyToTurnInText:
      'Were you able to reach Mining Town?',

  completedText:
      'Thanks for your help.',

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

final talkToForestForemanQuest =
    QuestDefinition(
  id: 'talk_to_forestForeman',
  title: 'Meet the Forest Foreman',
  description:
      'Travel to Forest Camp and speak with the Forest Foreman.',
  giverId: miningMerchant.id,

  availableText:
      'I need you to speak with the Forest Foreman at Forest Camp.',

  activeText:
      'Please visit Forest Camp and speak with the Forest Foreman.',

  readyToTurnInText:
      'Did you manage to speak with the Forest Foreman?',

  completedText:
      'Thank you for delivering my message.',

  requiredCompletedQuestIds: [
    'visit_miningTown',
  ],

  requiresTurnIn: true,

  objectives: [
    ObjectiveDefinition(
      type: 'talk_to_npc',
      params: {
        'npcId': 'forestForeman',
      },
    ),
  ],

  rewards: [
    RewardDefinition(
      type: 'gold',
      params: {
        'amount': 250,
      },
    ),
  ],
);