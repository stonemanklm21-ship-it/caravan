import '../models/city.dart';
import '../models/good.dart';

class DemandService {
  static double populationDemandPerDay({
    required City city,
    required Good good,
  }) {
    return city.population *
        good.populationDemandPerPersonPerDay;
  }

  static double industryDemandPerDay({
    required City city,
    required Good good,
  }) {
    double demand = 0;

    for (final industry in city.industries) {
      final input =
          industry.type.inputsPerSize[good];

      if (input != null) {
        demand += input * industry.size;
      }
    }

    return demand;
  }

  static double totalDemandPerDay({
    required City city,
    required Good good,
  }) {
    return populationDemandPerDay(
          city: city,
          good: good,
        ) +
        industryDemandPerDay(
          city: city,
          good: good,
        );
  }
}