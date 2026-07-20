import 'objective_handler.dart';

class ObjectiveHandlerRegistry {
  final Map<String, ObjectiveHandler>
      _handlers;

  ObjectiveHandlerRegistry({
    required Map<String, ObjectiveHandler>
        handlers,
  }) : _handlers = handlers;

  ObjectiveHandler? get(
    String objectiveType,
  ) {
    return _handlers[objectiveType];
  }
}