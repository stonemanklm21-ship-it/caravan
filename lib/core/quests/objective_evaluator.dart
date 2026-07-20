import 'objectives/objective_definition.dart';
import 'objectives/objective_progress.dart';

class ObjectiveEvaluator {
  static bool isComplete({
    required ObjectiveDefinition definition,
    required ObjectiveProgress progress,
  }) {
    switch (definition.type) {
      case 'visit_city':
        return progress.current >= 1;

      case 'deliver_goods':
        final quantity =
            definition.params['quantity']
                as int;

        return progress.current >= quantity;

      default:
        return false;
    }
  }
}