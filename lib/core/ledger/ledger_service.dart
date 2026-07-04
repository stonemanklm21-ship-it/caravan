import '../economy/market_observation.dart';
import '../models/player_state.dart';

class LedgerService {
  static void recordObservation({
    required PlayerState playerState,
    required String cityId,
    required String goodId,
    required double price,
  }) {
    playerState.ledger.observations.removeWhere(
      (observation) =>
          observation.cityId == cityId &&
          observation.goodId == goodId,
    );

    playerState.ledger.observations.add(
      MarketObservation(
        cityId: cityId,
        goodId: goodId,
        price: price,
        day: playerState.day,
        hour: playerState.hour,
      ),
    );
  }

  static MarketObservation? latestObservation({
    required PlayerState playerState,
    required String cityId,
    required String goodId,
  }) {
    try {
      return playerState.ledger.observations.firstWhere(
        (observation) =>
            observation.cityId == cityId &&
            observation.goodId == goodId,
      );
    } catch (_) {
      return null;
    }
  }

  static List<MarketObservation> observationsForCity({
    required PlayerState playerState,
    required String cityId,
  }) {
    final observations =
        playerState.ledger.observations
            .where(
              (observation) =>
                  observation.cityId ==
                  cityId,
            )
            .toList();

    observations.sort(
      (a, b) => a.goodId.compareTo(
        b.goodId,
      ),
    );

    return observations;
  }

  static List<MarketObservation> observationsForGood({
    required PlayerState playerState,
    required String goodId,
  }) {
    final observations =
        playerState.ledger.observations
            .where(
              (observation) =>
                  observation.goodId ==
                  goodId,
            )
            .toList();

    observations.sort(
      (a, b) => a.price.compareTo(
        b.price,
      ),
    );

    return observations;
  }
}