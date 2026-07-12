import 'dart:math' as math;

import 'package:flutter/material.dart';

class WorldMapHeading extends StatelessWidget {
  final double headingDegrees;

  const WorldMapHeading({
    super.key,
    required this.headingDegrees,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Row(
      mainAxisSize:
          MainAxisSize.min,
      children: [
        Transform.rotate(
          angle:
              headingDegrees *
              math.pi /
              180,
          child: const Icon(
            Icons.navigation,
            size: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          '${headingDegrees.round()}°',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
