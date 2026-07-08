import 'package:flutter/material.dart';

import '../core/models/city.dart';
import '../core/models/player_state.dart';
import '../core/models/world.dart';
import '../core/travel/journey_service.dart';
import '../core/travel/travel_service.dart';
import '../core/world/time_controller.dart';
import '../core/world/time_speed.dart';
import '../widgets/travel_confirmation_dialog.dart';

class WorldMapTravelService {
  static Future<void> travelToCity({
    required BuildContext context,
    required PlayerState playerState,
    required City city,
    required World world,
    required TimeController timeController,
    required VoidCallback onChanged,
  }) async {
    final confirmed =
        await showDialog<bool>(
      context: context,
      builder: (_) =>
          TravelConfirmationDialog(
        playerState: playerState,
        destination: city,
      ),
    );

    if (confirmed != true) {
      return;
    }

    final tickFraction =
        timeController.tickFraction;

    final originX =
        JourneyService.currentXSmooth(
      playerState,
      tickFraction,
    );

    final originY =
        JourneyService.currentYSmooth(
      playerState,
      tickFraction,
    );

    TravelService.startTravel(
      playerState: playerState,
      destination: city,
      originX: originX,
      originY: originY,
      tickFractionOffset:
          tickFraction,
    );

    if (timeController.currentSpeed ==
        TimeSpeed.paused) {
      timeController.setSpeed(
        speed: TimeSpeed.x1,
        playerState: playerState,
        world: world,
        onTick: onChanged,
      );
    }

    onChanged();
  }

  static Future<void>
      travelToCoordinates({
    required BuildContext context,
    required PlayerState playerState,
    required double destinationX,
    required double destinationY,
    required World world,
    required TimeController timeController,
    required VoidCallback onChanged,
  }) async {
    if (playerState.currentCity !=
        null) {
      final confirmed =
          await showDialog<bool>(
        context: context,
        builder: (_) =>
            TravelConfirmationDialog(
          playerState: playerState,
          destinationX:
              destinationX,
          destinationY:
              destinationY,
        ),
      );

      if (confirmed != true) {
        return;
      }
    }

    final tickFraction =
        timeController.tickFraction;

    final originX =
        JourneyService.currentXSmooth(
      playerState,
      tickFraction,
    );

    final originY =
        JourneyService.currentYSmooth(
      playerState,
      tickFraction,
    );

    TravelService
        .startTravelToCoordinates(
      playerState: playerState,
      destinationX: destinationX,
      destinationY: destinationY,
      originX: originX,
      originY: originY,
      tickFractionOffset:
          tickFraction,
    );

    if (timeController.currentSpeed ==
        TimeSpeed.paused) {
      timeController.setSpeed(
        speed: TimeSpeed.x1,
        playerState: playerState,
        world: world,
        onTick: onChanged,
      );
    }

    onChanged();
  }
}