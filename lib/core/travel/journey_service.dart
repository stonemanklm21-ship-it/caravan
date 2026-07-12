import 'dart:math';

import '../caravan/caravan_service.dart';
import '../models/city.dart';
import '../models/player_state.dart';
import '../travel/active_journey.dart';

class JourneyService {
  static const double mapUnitsPerDay =
      500;

  static ActiveJourney startJourney({
    required PlayerState playerState,
    required City destination,
    City? originCity,
    double? originX,
    double? originY,
    double tickFractionOffset = 0,
  }) {
    if (!CaravanService.canTravel(
      playerState.caravan,
    )) {
      throw StateError(
        'Caravan has no usable draft animal and vehicle.',
      );
    }

    final startX =
        originX ??
        currentX(playerState);

    final startY =
        originY ??
        currentY(playerState);

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
            playerState.caravan.speed);

    final travelHours =
        travelDays * 24;

    final journey = ActiveJourney(
      originX: startX,
      originY: startY,
      originCity: originCity,
      destinationX:
          destination.x,
      destinationY:
          destination.y,
      destinationCity:
          destination,
      totalHours: travelHours,
      tickFractionOffset:
          tickFractionOffset,
    );

    playerState.activeJourney =
        journey;

    return journey;
  }

  static ActiveJourney
      startJourneyToCoordinates({
    required PlayerState playerState,
    City? originCity,
    required double destinationX,
    required double destinationY,
    double? originX,
    double? originY,
    double tickFractionOffset = 0,
  }) {
    if (!CaravanService.canTravel(
      playerState.caravan,
    )) {
      throw StateError(
        'Caravan has no usable draft animal and vehicle.',
      );
    }

    final startX =
        originX ??
        currentX(playerState);

    final startY =
        originY ??
        currentY(playerState);

    final dx =
        destinationX - startX;

    final dy =
        destinationY - startY;

    final distance = sqrt(
      (dx * dx) + (dy * dy),
    );

    final travelDays =
        distance /
        (mapUnitsPerDay *
            playerState.caravan.speed);

    final travelHours =
        travelDays * 24;

    final journey = ActiveJourney(
      originX: startX,
      originY: startY,
      originCity: originCity,
      destinationX:
          destinationX,
      destinationY:
          destinationY,
      totalHours: travelHours,
      tickFractionOffset:
          tickFractionOffset,
    );

    playerState.activeJourney =
        journey;

    return journey;
  }

  static void advanceJourney({
    required PlayerState playerState,
    required double hours,
  }) {
    final journey =
        playerState.activeJourney;

    if (journey == null) {
      return;
    }

    if (journey.tickFractionOffset >
        0) {
      journey.elapsedHours +=
          hours -
          journey.tickFractionOffset;

      journey.tickFractionOffset =
          0.0;
    } else {
      journey.elapsedHours +=
          hours;
    }

    if (journey.elapsedHours >
        journey.totalHours) {
      journey.elapsedHours =
          journey.totalHours;
    }
  }

  static double currentX(
    PlayerState playerState,
  ) {
    final journey =
        playerState.activeJourney;

    if (journey == null) {
      return playerState.worldX;
    }

    return journey.originX +
        ((journey.destinationX -
                journey.originX) *
            journey.progress);
  }

  static double currentY(
    PlayerState playerState,
  ) {
    final journey =
        playerState.activeJourney;

    if (journey == null) {
      return playerState.worldY;
    }

    return journey.originY +
        ((journey.destinationY -
                journey.originY) *
            journey.progress);
  }

  static double currentXSmooth(
    PlayerState playerState,
    double tickFraction,
  ) {
    final journey =
        playerState.activeJourney;

    if (journey == null) {
      return playerState.worldX;
    }

    final effectiveFraction =
        (tickFraction -
                journey
                    .tickFractionOffset)
            .clamp(0.0, 1.0);

    final progress =
        ((journey.elapsedHours +
                    effectiveFraction) /
                journey.totalHours)
            .clamp(0.0, 1.0);

    return journey.originX +
        ((journey.destinationX -
                journey.originX) *
            progress);
  }

  static double currentYSmooth(
    PlayerState playerState,
    double tickFraction,
  ) {
    final journey =
        playerState.activeJourney;

    if (journey == null) {
      return playerState.worldY;
    }

    final effectiveFraction =
        (tickFraction -
                journey
                    .tickFractionOffset)
            .clamp(0.0, 1.0);

    final progress =
        ((journey.elapsedHours +
                    effectiveFraction) /
                journey.totalHours)
            .clamp(0.0, 1.0);

    return journey.originY +
        ((journey.destinationY -
                journey.originY) *
            progress);
  }

  static bool hasActiveJourney(
    PlayerState playerState,
  ) {
    return playerState.activeJourney !=
        null;
  }

  static bool isComplete(
    PlayerState playerState,
  ) {
    final journey =
        playerState.activeJourney;

    if (journey == null) {
      return false;
    }

    return journey.completed;
  }

  static void completeJourney(
    PlayerState playerState,
  ) {
    final journey =
        playerState.activeJourney;

    if (journey == null) {
      return;
    }

    journey.elapsedHours =
        journey.totalHours;
  }

static void clearJourney(
  PlayerState playerState,
) {
  playerState.activeJourney =
      null;
}
}