import '../models/good.dart';

class EconomyBalanceService {
  static double supportedPopulationForOutput({
    required double outputPerDay,
    required Good good,
  }) {
    if (good.populationDemandPerPersonPerDay <= 0) {
      return 0;
    }

    return outputPerDay /
        good.populationDemandPerPersonPerDay;
  }
}