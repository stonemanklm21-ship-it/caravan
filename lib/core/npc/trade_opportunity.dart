import '../models/city.dart';
import '../models/good.dart';

class TradeOpportunity {
  final Good good;
  final City destination;
  final double profitPerUnit;

  const TradeOpportunity({
    required this.good,
    required this.destination,
    required this.profitPerUnit,
  });
}