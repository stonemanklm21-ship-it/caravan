import 'good.dart';

class MarketGood {
  final Good good;

  /// Quantity currently available
  /// in the city market.
  double quantity;

  MarketGood({
    required this.good,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'good': good.id,
      'quantity': quantity,
    };
  }

  factory MarketGood.fromJson({
    required Map<String, dynamic>
        json,
    required Good Function(
      String id,
    )
    goodForId,
  }) {
    return MarketGood(
      good: goodForId(
        json['good'] as String,
      ),
      quantity:
          (json['quantity'] as num)
              .toDouble(),
    );
  }
}