import 'active_journey.dart';

class TravelInterpolator {
  static double x(
    ActiveJourney journey,
    double hour,
  ) {
    final progress =
        journey.progressAt(hour);

    return journey.originX +
        ((journey.destinationX -
                journey.originX) *
            progress);
  }

  static double y(
    ActiveJourney journey,
    double hour,
  ) {
    final progress =
        journey.progressAt(hour);

    return journey.originY +
        ((journey.destinationY -
                journey.originY) *
            progress);
  }
}