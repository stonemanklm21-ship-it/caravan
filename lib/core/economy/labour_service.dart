import '../models/city.dart';

class LabourService {
  static double cityEfficiency({
    required City city,
  }) {
    final availableWorkers =
        city.population * 0.3;

    double requiredWorkers = 0;

    for (final industry
        in city.industries) {
      requiredWorkers +=
          industry.type.workersPerSize *
          industry.size;
    }

    if (requiredWorkers <= 0) {
      return 1;
    }

    final efficiency =
        availableWorkers /
        requiredWorkers;

    if (efficiency > 1) {
      return 1;
    }

    if (efficiency < 0) {
      return 0;
    }

    return efficiency;
  }
}