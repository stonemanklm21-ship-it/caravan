import 'dart:math';

import '../models/city.dart';
import '../models/npc_caravan.dart';
import '../travel/active_journey.dart';

class NpcTravelService {
  static const double mapUnitsPerDay = 500;

  static void startJourney({
    required NpcCaravan npc,
    required City destination,
  }) {
    final dx = destination.x - npc.worldX;
    final dy = destination.y - npc.worldY;

    final distance = sqrt(
      (dx * dx) + (dy * dy),
    );

    final travelDays =
        distance /
        (mapUnitsPerDay *
            npc.caravan.speed);

    final travelHours =
        travelDays * 24;

    npc.activeJourney = ActiveJourney(
      originX: npc.worldX,
      originY: npc.worldY,
      destinationX: destination.x,
      destinationY: destination.y,
      destinationCity: destination,
      totalHours: travelHours,
    );

    npc.currentCity = null;
  }

  static void advanceJourney({
    required NpcCaravan npc,
    required double hours,
  }) {
    final journey = npc.activeJourney;

    if (journey == null) {
      return;
    }

    journey.elapsedHours += hours;

    if (journey.elapsedHours >
        journey.totalHours) {
      journey.elapsedHours =
          journey.totalHours;
    }
  }

  static void arrive({
    required NpcCaravan npc,
  }) {
    final journey = npc.activeJourney;

    if (journey == null) {
      return;
    }

    npc.worldX =
        journey.destinationX;

    npc.worldY =
        journey.destinationY;

    npc.currentCity =
        journey.destinationCity;

    npc.activeJourney = null;
  }

  static double currentX(
    NpcCaravan npc,
  ) {
    final journey = npc.activeJourney;

    if (journey == null) {
      return npc.worldX;
    }

    return journey.originX +
        ((journey.destinationX -
                journey.originX) *
            journey.progress);
  }

  static double currentY(
    NpcCaravan npc,
  ) {
    final journey = npc.activeJourney;

    if (journey == null) {
      return npc.worldY;
    }

    return journey.originY +
        ((journey.destinationY -
                journey.originY) *
            journey.progress);
  }
}