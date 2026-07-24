import '../../events/game_event.dart';
import '../../events/npc_talked_event.dart';
import '../objectives/objective_definition.dart';
import '../objectives/objective_progress.dart';
import 'objective_handler.dart';

class TalkToNpcHandler
    implements ObjectiveHandler {
  @override
  void process({
    required GameEvent event,
    required ObjectiveDefinition definition,
    required ObjectiveProgress progress,
  }) {
    if (event is! NpcTalkedEvent) {
      return;
    }

    final targetNpcId =
        definition.params['npcId']
            as String;

    if (event.npcId != targetNpcId) {
      return;
    }

    progress.current = 1;
  }
}