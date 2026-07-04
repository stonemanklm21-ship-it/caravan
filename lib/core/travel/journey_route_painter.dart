import 'package:flutter/material.dart';

import '../models/player_state.dart';

class JourneyRoutePainter
    extends CustomPainter {
  final PlayerState playerState;

  JourneyRoutePainter({
    required this.playerState,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final journey =
        playerState.activeJourney;

    if (journey == null) {
      return;
    }

    final routePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3;

    canvas.drawLine(
      Offset(
        journey.originX,
        journey.originY,
      ),
      Offset(
        journey.destinationX,
        journey.destinationY,
      ),
      routePaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant JourneyRoutePainter
        oldDelegate,
  ) {
    return true;
  }
}