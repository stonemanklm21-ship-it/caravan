import 'dart:ui';

import 'world_map_constants.dart';

class WorldMapCamera {
  double x;
  double y;
  double zoom;

  WorldMapCamera({
    required this.x,
    required this.y,
    this.zoom = 1,
  });

  double minimumZoom({
    required Size viewportSize,
  }) {
    final zoomX =
        viewportSize.width /
        WorldMapConstants.worldWidth;

    final zoomY =
        viewportSize.height /
        WorldMapConstants.worldHeight;

    return zoomX > zoomY
        ? zoomX
        : zoomY;
  }

  void clampToWorld({
    required Size viewportSize,
  }) {
    final halfViewportWidth =
        viewportSize.width /
        (2 * zoom);

    final halfViewportHeight =
        viewportSize.height /
        (2 * zoom);

    const worldCenterX = 0.0;
    const worldCenterY = 0.0;

    if (halfViewportWidth * 2 >=
        WorldMapConstants.worldWidth) {
      x = worldCenterX;
    } else {
      x = x.clamp(
        WorldMapConstants.minX +
            halfViewportWidth,
        WorldMapConstants.maxX -
            halfViewportWidth,
      );
    }

    if (halfViewportHeight * 2 >=
        WorldMapConstants.worldHeight) {
      y = worldCenterY;
    } else {
      y = y.clamp(
        WorldMapConstants.minY +
            halfViewportHeight,
        WorldMapConstants.maxY -
            halfViewportHeight,
      );
    }
  }

  Offset worldToScreen({
    required double worldX,
    required double worldY,
    required Size viewportSize,
  }) {
    return Offset(
      (worldX - x) * zoom +
          viewportSize.width / 2,
      (worldY - y) * zoom +
          viewportSize.height / 2,
    );
  }

  Offset screenToWorld({
    required double screenX,
    required double screenY,
    required Size viewportSize,
  }) {
    return Offset(
      (screenX -
                  viewportSize.width /
                      2) /
              zoom +
          x,
      (screenY -
                  viewportSize.height /
                      2) /
              zoom +
          y,
    );
  }
}