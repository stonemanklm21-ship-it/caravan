import 'dart:math';

import '../models/world.dart';
import '../../data/game_balance.dart';

class BanditCityService {


static bool isInsideSafeZone({
  required double x,
  required double y,
  required World world,
}) {
  for (final city in world.cities) {
    final dx = x - city.x;
    final dy = y - city.y;

    final distance = sqrt(
      (dx * dx) +
      (dy * dy),
    );

  if (distance <=
    GameBalance.citySafeZoneRadius) {

      return true;
    }
  }

  return false;
}
}