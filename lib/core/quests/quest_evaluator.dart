import 'objective_evaluator.dart';
import 'quest_definition.dart';
import 'quest_instance.dart';

class QuestEvaluator {
  static bool isComplete({
    required QuestDefinition definition,
    required QuestInstance instance,
  }) {
    for (
      var i = 0;
      i < definition.objectives.length;
      i++
    ) {
      if (!ObjectiveEvaluator.isComplete(
        definition: definition.objectives[i],
        progress: instance.progress[i],
      )) {
        return false;
      }
    }

    return true;
  }
}