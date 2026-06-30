import 'package:flutter/material.dart';

import '../models/game_state.dart';

class JourneyRoutePainter extends CustomPainter {
  final GameState gameState;

  JourneyRoutePainter({
    required this.gameState,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final journey = gameState.activeJourney;

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
        journey.destination.x,
        journey.destination.y,
      ),
      routePaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant JourneyRoutePainter oldDelegate,
  ) {
    return true;
  }
}