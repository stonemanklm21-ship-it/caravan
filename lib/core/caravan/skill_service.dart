import 'dart:math';

class SkillService {
  static double asymptoticValue({
    required double skill,
    required double start,
    required double end,
    double halfLife = 100,
  }) {
    return end +
        (start - end) *
            pow(
              0.5,
              skill / halfLife,
            );
  }
}