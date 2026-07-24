import 'dart:math';

import '../caravan/skill_service.dart';

class VisibilityService {
  static const double banditVisionRange = 100.0;

  static double caravanVisionRange(
    int scoutSkill,
  ) {
    return SkillService.asymptoticValue(
      skill: scoutSkill.toDouble(),
      start: 40.0,
      end: 200.0,
    );
  }

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

    final distance = sqrt(
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