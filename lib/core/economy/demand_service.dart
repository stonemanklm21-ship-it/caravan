import '../models/city.dart';
import '../models/good.dart';
import '../../data/goods_data.dart';

class DemandService {
  static double populationDemandPerDay({
    required City city,
    required Good good,
  }) {
    if (good == bread) {
      return city.population * 0.01;
    }

    if (good == water) {
      return city.population * 0.01;
    }

    if (good == tools) {
      return city.population * 0.001;
    }

    if (good == wood) {
      return city.population * 0.002;
    }

    if (good == chair) {
      return city.population * 0.001;
    }

    return 0;
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