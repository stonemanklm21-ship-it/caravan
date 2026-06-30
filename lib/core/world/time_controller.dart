import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/game_state.dart';
import '../models/world.dart';
import 'simulation_service.dart';
import 'time_speed.dart';

class TimeController {
  Timer? _timer;

  TimeSpeed currentSpeed =
      TimeSpeed.paused;

  bool get isRunning =>
      currentSpeed != TimeSpeed.paused;

  void setSpeed({
    required TimeSpeed speed,
    required GameState gameState,
    required World world,
    required VoidCallback onTick,
  }) {
    stop();

    currentSpeed = speed;

    if (speed == TimeSpeed.paused) {
      return;
    }

    int ticksPerSecond;

    switch (speed) {
      case TimeSpeed.x1:
        ticksPerSecond = 1;
        break;

      case TimeSpeed.x4:
        ticksPerSecond = 4;
        break;

      case TimeSpeed.x24:
        ticksPerSecond = 24;
        break;

      case TimeSpeed.paused:
        ticksPerSecond = 0;
        break;
    }

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        for (
          int i = 0;
          i < ticksPerSecond;
          i++
        ) {
          SimulationService.tick(
            gameState: gameState,
            world: world,
          );
        }

        onTick();
      },
    );
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    currentSpeed = TimeSpeed.paused;
  }

  void dispose() {
    stop();
  }
}