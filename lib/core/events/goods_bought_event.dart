import 'game_event.dart';

class GoodsBoughtEvent extends GameEvent {
  final String cityId;

  final String goodId;

  final int quantity;

  const GoodsBoughtEvent({
    required this.cityId,
    required this.goodId,
    required this.quantity,
  });
}