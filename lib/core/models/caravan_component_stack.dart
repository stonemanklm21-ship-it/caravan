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
}