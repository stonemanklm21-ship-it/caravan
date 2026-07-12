import 'dart:math' as math;

class WorldMapNavigation {
  static double headingDegrees({
    required double fromX,
    required double fromY,
    required double toX,
    required double toY,
  }) {
    final dx = toX - fromX;
    final dy = toY - fromY;

    final radians =
        math.atan2(dx, -dy);

    final degrees =
        radians * 180 / math.pi;

    return (degrees + 360) % 360;
  }
}