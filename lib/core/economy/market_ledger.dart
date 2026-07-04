import 'market_observation.dart';

class MarketLedger {
  final List<MarketObservation>
      observations;

  MarketLedger({
    List<MarketObservation>?
        observations,
  }) : observations =
            observations ?? [];

  Map<String, dynamic> toJson() {
    return {
      'observations':
          observations
              .map(
                (observation) =>
                    observation
                        .toJson(),
              )
              .toList(),
    };
  }

  factory MarketLedger.fromJson(
    Map<String, dynamic> json,
  ) {
    return MarketLedger(
      observations:
          (json['observations']
                  as List)
              .map(
                (observation) =>
                    MarketObservation
                        .fromJson(
                  observation,
                ),
              )
              .toList(),
    );
  }
}