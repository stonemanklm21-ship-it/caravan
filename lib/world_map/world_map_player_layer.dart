import 'package:flutter/material.dart';

import 'world_map_camera.dart';
import 'world_map_player_marker.dart';

class WorldMapPlayerLayer
    extends StatelessWidget {
  final double playerX;
  final double playerY;
  final double headingDegrees;
  final WorldMapCamera camera;
  final Size viewportSize;

  const WorldMapPlayerLayer({
    super.key,
    required this.playerX,
    required this.playerY,
    required this.headingDegrees,
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

final markerSize =
    (24 * camera.zoom).clamp(
      12.0,
      36.0,
    );

return Positioned(
  left:
      screenPosition.dx -
      markerSize / 2,
  top:
      screenPosition.dy -
      markerSize / 2,
  child: WorldMapPlayerMarker(
    headingDegrees:
        headingDegrees,
    zoom: camera.zoom,
  ),
);
  }
}