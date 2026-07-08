import '../models/caravan.dart';
import '../models/industry.dart';

class IndustryOwnershipService {
  static double purchasePrice(
    Industry industry,
  ) {
    return industry.cash * 2;
  }

  static bool buyIndustry({
    required Caravan caravan,
    required Industry industry,
  }) {
    if (industry.playerOwned) {
      return false;
    }

    final price =
        purchasePrice(industry);

    if (caravan.gold < price) {
      return false;
    }

    caravan.gold -= price;
    industry.playerOwned = true;

    return true;
  }

  static bool collectCash({
    required Caravan caravan,
    required Industry industry,
  }) {
    if (!industry.playerOwned) {
      return false;
    }

    if (industry.cash <= 0) {
      return false;
    }

    caravan.gold += industry.cash;
    industry.cash = 0;

    return true;
  }
}