import 'good.dart';

class IndustryInventoryItem {
  final Good good;

  double quantity;

  IndustryInventoryItem({
    required this.good,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'good': good.id,
      'quantity': quantity,
    };
  }
}