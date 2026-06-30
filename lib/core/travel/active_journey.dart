import '../models/city.dart';

class ActiveJourney {
  final double originX;
  final double originY;

  final City destination;

  final double totalHours;

  double elapsedHours;

  ActiveJourney({
    required this.originX,
    required this.originY,
    required this.destination,
    required this.totalHours,
    this.elapsedHours = 0,
  });

  double get progress {
    if (totalHours <= 0) {
      return 1;
    }

    return elapsedHours / totalHours;
  }

  bool get completed {
    return elapsedHours >= totalHours;
  }

  double get remainingHours {
    return totalHours - elapsedHours;
  }
}