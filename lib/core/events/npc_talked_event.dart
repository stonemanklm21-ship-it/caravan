import 'game_event.dart';

class NpcTalkedEvent extends GameEvent {
  final String npcId;

  const NpcTalkedEvent({
    required this.npcId,
  });
}