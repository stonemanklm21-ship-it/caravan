import 'dart:math' as math;

import 'package:flutter/material.dart';

class WorldMapPlayerMarker
    extends StatelessWidget {
  final double headingDegrees;
  final double zoom;

  const WorldMapPlayerMarker({
    super.key,
    required this.headingDegrees,
    required this.zoom,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final markerSize =
        (24 * zoom).clamp(
          12.0,
          36.0,
        );

    final arrowSize =
        markerSize * 0.5;

    return Container(
      width: markerSize,
      height: markerSize,
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
      ),
      child: Center(
        child: Transform.rotate(
          angle:
              headingDegrees *
              math.pi /
              180,
          child: Icon(
            Icons.navigation,
            size: arrowSize,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}