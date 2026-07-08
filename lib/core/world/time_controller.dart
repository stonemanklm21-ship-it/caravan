import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/player_state.dart';
import '../models/world.dart';
import 'simulation_service.dart';
import 'time_speed.dart';

class TimeController {
  Timer? _timer;

  DateTime? _lastTickTime;

  double _pausedTickFraction = 0.0;

  static const Duration tickDuration =
      Duration(seconds: 1);

  TimeSpeed currentSpeed =
      TimeSpeed.paused;

  bool get isRunning =>
      currentSpeed != TimeSpeed.paused;

  /// 0.0 -> 1.0 progress through current tick
  double get tickFraction {
    if (currentSpeed ==
        TimeSpeed.paused) {
      return _pausedTickFraction;
    }

    if (_lastTickTime == null) {
      return _pausedTickFraction;
    }

    final elapsed =
        DateTime.now()
            .difference(
      _lastTickTime!,
    );

    return (_pausedTickFraction +
            (elapsed.inMilliseconds /
                tickDuration
                    .inMilliseconds))
        .clamp(0.0, 1.0);
  }

  void setSpeed({
    required TimeSpeed speed,
    required PlayerState playerState,
    required World world,
    required VoidCallback onTick,
  }) {
    if (currentSpeed == speed) {
      return;
    }

    final resumeFraction =
        _pausedTickFraction;

    stop();

    currentSpeed = speed;

    if (speed == TimeSpeed.paused) {
      return;
    }

    _pausedTickFraction =
        resumeFraction;

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

    _lastTickTime = DateTime.now();

    _timer = Timer.periodic(
      tickDuration,
      (_) {
        _pausedTickFraction = 0.0;

        _lastTickTime = DateTime.now();

        for (
          int i = 0;
          i < ticksPerSecond;
          i++
        ) {
          SimulationService.tick(
            playerState: playerState,
            world: world,
          );
        }

        onTick();
      },
    );
  }

  void stop() {
    _pausedTickFraction =
        tickFraction;

    _timer?.cancel();
    _timer = null;

    currentSpeed = TimeSpeed.paused;
  }

  void dispose() {
    stop();
  }
}