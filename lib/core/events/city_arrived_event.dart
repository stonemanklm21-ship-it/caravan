import 'game_event.dart';

class CityArrivedEvent extends GameEvent {
  final String cityId;

  const CityArrivedEvent({
    required this.cityId,
  });
}