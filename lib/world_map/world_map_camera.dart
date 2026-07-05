import 'dart:ui';

class WorldMapCamera {
  double x;
  double y;
  double zoom;

  WorldMapCamera({
    required this.x,
    required this.y,
    this.zoom = 1,
  });

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