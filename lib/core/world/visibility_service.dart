import 'dart:math';

class VisibilityService {
  
  static const double caravanVisionRange = 300.0;
  static const double banditVisionRange = 40.0;

  static bool canSee({
    required double observerX,
    required double observerY,
    required double targetX,
    required double targetY,
    required double range,
  }) {
    final dx =
        observerX - targetX;

    final dy =
        observerY - targetY;

    final distance =
        sqrt(
      (dx * dx) +
          (dy * dy),
    );

    return distance <= range;
  }

  static double distance({
    required double x1,
    required double y1,
    required double x2,
    required double y2,
  }) {
    final dx = x1 - x2;
    final dy = y1 - y2;

    return sqrt(
      (dx * dx) +
          (dy * dy),
    );
  }
}