import 'dart:math';

import '../travel/active_journey.dart';
import '../models/city.dart';
import '../models/game_state.dart';

class JourneyService {
  static const double mapUnitsPerDay = 500;

  static ActiveJourney startJourney({
    required GameState gameState,
    required City destination,
  }) {
    final originX = currentX(gameState);
    final originY = currentY(gameState);

    final dx = destination.x - originX;
    final dy = destination.y - originY;

    final distance = sqrt(
      (dx * dx) + (dy * dy),
    );

    final travelDays =
        distance /
        (mapUnitsPerDay * gameState.caravan.speed);

    final travelHours = travelDays * 24;

    final journey = ActiveJourney(
      originX: originX,
      originY: originY,
      destination: destination,
      totalHours: travelHours,
    );

    gameState.activeJourney = journey;

    return journey;
  }

  static void advanceJourney({
    required GameState gameState,
    required double hours,
  }) {
    final journey = gameState.activeJourney;

    if (journey == null) {
      return;
    }

    journey.elapsedHours += hours;

    if (journey.elapsedHours > journey.totalHours) {
      journey.elapsedHours = journey.totalHours;
    }
  }

  static double currentX(
    GameState gameState,
  ) {
    final journey = gameState.activeJourney;

    if (journey == null) {
      return gameState.worldX;
    }

    return journey.originX +
        ((journey.destination.x -
                journey.originX) *
            journey.progress);
  }

  static double currentY(
    GameState gameState,
  ) {
    final journey = gameState.activeJourney;

    if (journey == null) {
      return gameState.worldY;
    }

    return journey.originY +
        ((journey.destination.y -
                journey.originY) *
            journey.progress);
  }

  static bool hasActiveJourney(
    GameState gameState,
  ) {
    return gameState.activeJourney != null;
  }

  static bool isComplete(
    GameState gameState,
  ) {
    final journey = gameState.activeJourney;

    if (journey == null) {
      return false;
    }

    return journey.completed;
  }

  static void completeJourney(
    GameState gameState,
  ) {
    final journey = gameState.activeJourney;

    if (journey == null) {
      return;
    }

    journey.elapsedHours = journey.totalHours;
  }

  static void clearJourney(
    GameState gameState,
  ) {
    gameState.activeJourney = null;
  }
}