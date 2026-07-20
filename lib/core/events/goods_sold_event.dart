import 'game_event.dart';

class GoodsSoldEvent extends GameEvent {
  final String cityId;

  final String goodId;

  final int quantity;

  const GoodsSoldEvent({
    required this.cityId,
    required this.goodId,
    required this.quantity,
  });
}