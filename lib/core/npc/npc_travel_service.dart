import 'dart:math';

import '../models/city.dart';
import '../models/npc_caravan.dart';
import '../travel/active_journey.dart';

class NpcTravelService {
  static const double mapUnitsPerDay = 500;

  static void startJourney({
    required NpcCaravan npc,
    required City destination,
    double? originX,
    double? originY,
  }) {
    final startX =
        originX ?? npc.worldX;

    final startY =
        originY ?? npc.worldY;

    final dx =
        destination.x - startX;

    final dy =
        destination.y - startY;

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
      originX: startX,
      originY: startY,
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

  static double currentXSmooth(
    NpcCaravan npc,
    double tickFraction,
  ) {
    final journey = npc.activeJourney;

    if (journey == null) {
      return npc.worldX;
    }

    final progress =
        ((journey.elapsedHours +
                    tickFraction) /
                journey.totalHours)
            .clamp(0.0, 1.0);

    return journey.originX +
        ((journey.destinationX -
                journey.originX) *
            progress);
  }

  static double currentYSmooth(
    NpcCaravan npc,
    double tickFraction,
  ) {
    final journey = npc.activeJourney;

    if (journey == null) {
      return npc.worldY;
    }

    final progress =
        ((journey.elapsedHours +
                    tickFraction) /
                journey.totalHours)
            .clamp(0.0, 1.0);

    return journey.originY +
        ((journey.destinationY -
                journey.originY) *
            progress);
  }
}