class MarketObservation {
  final String cityId;

  final String goodId;

  final double price;

  final int day;

  final int hour;

  const MarketObservation({
    required this.cityId,
    required this.goodId,
    required this.price,
    required this.day,
    required this.hour,
  });

  Map<String, dynamic> toJson() {
    return {
      'cityId': cityId,
      'goodId': goodId,
      'price': price,
      'day': day,
      'hour': hour,
    };
  }

  factory MarketObservation.fromJson(
    Map<String, dynamic> json,
  ) {
    return MarketObservation(
      cityId:
          json['cityId'] as String,
      goodId:
          json['goodId'] as String,
      price:
          (json['price'] as num)
              .toDouble(),
      day: json['day'] as int,
      hour: json['hour'] as int,
    );
  }
}