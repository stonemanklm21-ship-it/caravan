import 'dart:math';

import '../caravan/caravan_service.dart';
import '../models/city.dart';
import '../models/player_state.dart';
import '../travel/active_journey.dart';
import '../travel/journey_factory.dart';
import '../travel/travel_interpolator.dart';

class JourneyService {
  static ActiveJourney startJourney({
    required PlayerState playerState,
    required City destination,
    required double departureHour,
    City? originCity,
    double? originX,
    double? originY,
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

    final journey =
        JourneyFactory.create(
      originX: startX,
      originY: startY,
      destinationX: destination.x,
      destinationY: destination.y,
      originCity: originCity,
      destinationCity: destination,
      speed:
          playerState.caravan.speed,
      departureHour: departureHour,
    );

    playerState.activeJourney =
        journey;

    return journey;
  }

  static ActiveJourney
      startJourneyToCoordinates({
    required PlayerState playerState,
    required double departureHour,
    City? originCity,
    required double destinationX,
    required double destinationY,
    double? originX,
    double? originY,
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

    final journey =
        JourneyFactory.create(
      originX: startX,
      originY: startY,
      destinationX: destinationX,
      destinationY: destinationY,
      originCity: originCity,
      speed:
          playerState.caravan.speed,
      departureHour: departureHour,
    );

    playerState.activeJourney =
        journey;

    return journey;
  }

  static double currentX(
    PlayerState playerState,
  ) {
    final journey =
        playerState.activeJourney;

    if (journey == null) {
      return playerState.worldX;
    }

    return TravelInterpolator.x(
      journey,
      playerState.worldTimeHours,
    );
  }

  static double currentY(
    PlayerState playerState,
  ) {
    final journey =
        playerState.activeJourney;

    if (journey == null) {
      return playerState.worldY;
    }

    return TravelInterpolator.y(
      journey,
      playerState.worldTimeHours,
    );
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

    return TravelInterpolator.x(
      journey,
      playerState.worldTimeHours +
          tickFraction,
    );
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

    return TravelInterpolator.y(
      journey,
      playerState.worldTimeHours +
          tickFraction,
    );
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

    return journey.completedAt(
      playerState.worldTimeHours,
    );
  }

  static void completeJourney(
    PlayerState playerState,
  ) {
    final journey =
        playerState.activeJourney;

    if (journey == null) {
      return;
    }

    playerState.worldTimeHours =
        max(
      playerState.worldTimeHours,
      journey.arrivalHour,
    );
  }

  static void clearJourney(
    PlayerState playerState,
  ) {
    playerState.activeJourney =
        null;
  }
}