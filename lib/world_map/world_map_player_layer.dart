import 'package:flutter/material.dart';

import 'world_map_camera.dart';

class WorldMapPlayerLayer extends StatelessWidget {
  final double playerX;
  final double playerY;
  final WorldMapCamera camera;
  final Size viewportSize;

  const WorldMapPlayerLayer({
    super.key,
    required this.playerX,
    required this.playerY,
    required this.camera,
    required this.viewportSize,
  });

  @override
  Widget build(BuildContext context) {
    final screenPosition =
        camera.worldToScreen(
      worldX: playerX,
      worldY: playerY,
      viewportSize: viewportSize,
    );

    return Positioned(
      left: screenPosition.dx,
      top: screenPosition.dy,
      child: const Icon(
        Icons.person_pin_circle,
        color: Colors.red,
        size: 40,
      ),
    );
  }
}