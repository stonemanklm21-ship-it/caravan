import 'dart:math';

import '../caravan/caravan_service.dart';
import '../travel/active_journey.dart';
import '../models/city.dart';
import '../models/player_state.dart';

class JourneyService {
  static const double mapUnitsPerDay =
      500;

  static ActiveJourney startJourney({
    required PlayerState playerState,
    required City destination,
  }) {
    if (!CaravanService.canTravel(
      playerState.caravan,
    )) {
      throw StateError(
        'Caravan has no usable draft animal and vehicle.',
      );
    }

    final originX =
        currentX(playerState);

    final originY =
        currentY(playerState);

    final dx =
        destination.x - originX;

    final dy =
        destination.y - originY;

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
      originX: originX,
      originY: originY,
      destinationX:
          destination.x,
      destinationY:
          destination.y,
      destinationCity:
          destination,
      totalHours: travelHours,
    );

    playerState.activeJourney =
        journey;

    return journey;
  }

  static ActiveJourney
      startJourneyToCoordinates({
    required PlayerState playerState,
    required double destinationX,
    required double destinationY,
  }) {
    if (!CaravanService.canTravel(
      playerState.caravan,
    )) {
      throw StateError(
        'Caravan has no usable draft animal and vehicle.',
      );
    }

    final originX =
        currentX(playerState);

    final originY =
        currentY(playerState);

    final dx =
        destinationX - originX;

    final dy =
        destinationY - originY;

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
      originX: originX,
      originY: originY,
      destinationX:
          destinationX,
      destinationY:
          destinationY,
      totalHours: travelHours,
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

    journey.elapsedHours += hours;

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