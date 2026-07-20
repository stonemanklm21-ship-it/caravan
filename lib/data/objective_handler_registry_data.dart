import '../core/quests/handlers/objective_handler_registry.dart';
import '../core/quests/handlers/visit_city_handler.dart';

final objectiveHandlerRegistry =
    ObjectiveHandlerRegistry(
  handlers: {
    'visit_city': VisitCityHandler(),
  },
);