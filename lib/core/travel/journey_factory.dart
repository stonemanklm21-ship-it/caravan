import '../models/city.dart';
import 'active_journey.dart';
import 'journey_calculator.dart';

class JourneyFactory {
  static ActiveJourney create({
    required double originX,
    required double originY,
    required double destinationX,
    required double destinationY,
    required double speed,
    required double departureHour,
    City? originCity,
    City? destinationCity,
  }) {
    final distance =
        JourneyCalculator.distance(
      originX: originX,                 originY: originY,
      destinationX: destinationX,       destinationY: destinationY,
    );

    final travelHours =
        JourneyCalculator.travelHours(distance: distance, speed: speed,);

    return ActiveJourney(
      originX:          originX,
      originY:          originY,
      originCity:       originCity,
      destinationX:     destinationX,
      destinationY:     destinationY,
      destinationCity:  destinationCity,
      departureHour:    departureHour,
      arrivalHour:      departureHour + travelHours,
    );
  }
}