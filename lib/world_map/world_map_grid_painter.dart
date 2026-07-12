import 'package:flutter/material.dart';

class WorldMapGridPainter
    extends CustomPainter {
  final double zoom;

  const WorldMapGridPainter({
    required this.zoom,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final gridPaint = Paint()
      ..color = Colors.black54
      ..strokeWidth = 1;

    final axisPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3;

    const worldGridSpacing = 500.0;

    final screenSpacing =
        worldGridSpacing * zoom;

    for (
      double x = 0;
      x < size.width;
      x += screenSpacing
    ) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }

    for (
      double y = 0;
      y < size.height;
      y += screenSpacing
    ) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(
        size.width / 2,
        size.height,
      ),
      axisPaint,
    );

    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(
        size.width,
        size.height / 2,
      ),
      axisPaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant WorldMapGridPainter oldDelegate,
  ) {
    return oldDelegate.zoom != zoom;
  }
}