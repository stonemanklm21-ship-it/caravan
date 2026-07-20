// lib/core/quests/handlers/visit_city_handler.dart

import '../../events/city_arrived_event.dart';
import '../../events/game_event.dart';
import '../objectives/objective_definition.dart';
import '../objectives/objective_progress.dart';
import 'objective_handler.dart';

class VisitCityHandler implements ObjectiveHandler {
  @override
  void process({
    required GameEvent event,
    required ObjectiveDefinition definition,
    required ObjectiveProgress progress,
  }) {
    if (event is! CityArrivedEvent) {
      return;
    }

    final targetCityId =
        definition.params['cityId'] as String;

    if (event.cityId != targetCityId) {
      return;
    }

    progress.current = 1;
  }
}