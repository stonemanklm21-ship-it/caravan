// objective_handler.dart

import '../../events/game_event.dart';
import '../objectives/objective_definition.dart';
import '../objectives/objective_progress.dart';

abstract class ObjectiveHandler {
  void process({
    required GameEvent event,
    required ObjectiveDefinition definition,
    required ObjectiveProgress progress,
  });
}