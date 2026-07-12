class CargoManifestEntry {
  final String goodId;
  final String destinationCityId;
  final int quantity;

  CargoManifestEntry({
    required this.goodId,
    required this.destinationCityId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'goodId': goodId,
      'destinationCityId':
          destinationCityId,
      'quantity': quantity,
    };
  }

  factory CargoManifestEntry.fromJson(
    Map<String, dynamic> json,
  ) {
    return CargoManifestEntry(
      goodId:
          json['goodId'] as String,
      destinationCityId:
          json['destinationCityId']
              as String,
      quantity:
          json['quantity'] as int,
    );
  }
}