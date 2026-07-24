import '../core/quests/handlers/objective_handler_registry.dart';
import '../core/quests/handlers/talk_to_npc_handler.dart';
import '../core/quests/handlers/visit_city_handler.dart';

final objectiveHandlerRegistry =
    ObjectiveHandlerRegistry(
  handlers: {
    'visit_city': VisitCityHandler(),
    'talk_to_npc': TalkToNpcHandler(),
  },
);