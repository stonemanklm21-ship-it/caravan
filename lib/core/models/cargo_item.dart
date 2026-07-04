import '../../data/goods_data.dart';
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

  Map<String, dynamic> toJson() {
    return {
      'good': good.id,
      'quantity': quantity,
    };
  }

  factory CargoItem.fromJson(
    Map<String, dynamic> json,
  ) {
final goodId =
    json['good'] as String;

final good = goodForId(
  goodId,
);

    return CargoItem(
      good: good,
      quantity:
          (json['quantity'] as num)
              .toDouble(),
    );
  }
}