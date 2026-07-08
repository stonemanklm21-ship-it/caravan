import 'city.dart';
import 'good.dart';

class TradeMission {
  final Good good;

  final City origin;

  final City destination;

  final int quantity;

  final double expectedBuyPrice;

  final double expectedSellPrice;

  final double expectedProfit;

  const TradeMission({
    required this.good,
    required this.origin,
    required this.destination,
    required this.quantity,
    required this.expectedBuyPrice,
    required this.expectedSellPrice,
    required this.expectedProfit,
  });
}