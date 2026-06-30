  import 'good.dart';

class CargoItem {
  final Good good;

  double quantity;

  CargoItem({
    required this.good,
    required this.quantity,
  });

  double get totalWeightKg {
    return good.weight * quantity;
  }
}