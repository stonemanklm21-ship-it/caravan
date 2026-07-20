import 'reward_handler.dart';

class RewardHandlerRegistry {
  final Map<String, RewardHandler>
      _handlers;

  RewardHandlerRegistry({
    required Map<String, RewardHandler>
        handlers,
  }) : _handlers = handlers;

  RewardHandler? get(String type) {
    return _handlers[type];
  }
}