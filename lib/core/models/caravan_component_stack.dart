import '/data/caravan_components_data.dart';
import 'caravan_component.dart';

class CaravanComponentStack {
  final CaravanComponent component;

  int quantity;

  CaravanComponentStack({
    required this.component,
    required this.quantity,
  });

  double get totalCargoCapacityKg {
    return component.cargoCapacityKg * quantity;
  }

  double get travelSpeed {
    return component.travelSpeed;
  }

  double get totalPurchasePrice {
    return component.purchasePrice * quantity;
  }

  Map<String, dynamic> toJson() {
    return {
      'component': component.id,
      'quantity': quantity,
    };
  }

  factory CaravanComponentStack.fromJson(
    Map<String, dynamic> json,
  ) {
    final componentId =
        json['component'] as String;

    final component =
        componentForId(
      componentId,
    );

    return CaravanComponentStack(
      component: component,
      quantity: json['quantity'] as int,
    );
  }
}