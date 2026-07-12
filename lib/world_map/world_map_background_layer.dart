import 'package:flutter/material.dart';

import 'world_map_camera.dart';
import 'world_map_constants.dart';

class WorldMapBackgroundLayer
    extends StatelessWidget {
  final WorldMapCamera camera;
  final Size viewportSize;

  const WorldMapBackgroundLayer({
    super.key,
    required this.camera,
    required this.viewportSize,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final topLeft =
        camera.worldToScreen(
      worldX: WorldMapConstants.minX,
      worldY: WorldMapConstants.minY,
      viewportSize: viewportSize,
    );

    return Positioned(
      left: topLeft.dx,
      top: topLeft.dy,
      child: Container(
        width:
            WorldMapConstants.worldWidth *
            camera.zoom,
        height:
            WorldMapConstants.worldHeight *
            camera.zoom,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/textures/grass.png',
            ),
            repeat: ImageRepeat.repeat,
          ),
        ),
      ),
    );
  }
}