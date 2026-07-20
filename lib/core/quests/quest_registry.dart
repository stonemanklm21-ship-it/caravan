import 'quest_definition.dart';

class QuestRegistry {
  final Map<String, QuestDefinition>
      _definitions;

  QuestRegistry(
    this._definitions,
  );

  QuestDefinition? get(String id) {
    return _definitions[id];
  }

  Iterable<QuestDefinition>
  get definitions =>
      _definitions.values;

  List<QuestDefinition> getByGiver(
    String giverId,
  ) {
    return _definitions.values
        .where(
          (quest) =>
              quest.giverId == giverId,
        )
        .toList();
  }
}