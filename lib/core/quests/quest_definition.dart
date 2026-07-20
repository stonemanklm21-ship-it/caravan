import 'objectives/objective_definition.dart';
import 'reward_definition.dart';

class QuestDefinition {
  final String id;

  final String title;

  final String description;

  final String giverId;

  /// Whether the player must return to the
  /// quest giver before the quest is completed.
  final bool requiresTurnIn;

  final List<ObjectiveDefinition> objectives;

  final List<RewardDefinition> rewards;

  const QuestDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.giverId,
    required this.requiresTurnIn,
    required this.objectives,
    required this.rewards,
  });
}