import '../economy/market_observation.dart';
import '../models/player_state.dart';

class LedgerService {
  static void recordObservation({
    required PlayerState playerState,
    required String cityId,
    required String goodId,
    required double price,
  }) {
    final alreadyRecorded =
        playerState.ledger.observations.any(
      (observation) =>
          observation.cityId == cityId &&
          observation.goodId == goodId &&
          observation.day == playerState.day,
    );

    if (alreadyRecorded) {
      return;
    }

    print(
      'Recording $goodId in $cityId on day ${playerState.day} at $price',
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
      return playerState.ledger.observations
          .where(
            (observation) =>
                observation.cityId == cityId &&
                observation.goodId == goodId,
          )
          .reduce(
            (a, b) {
              final aTime = a.day * 24 + a.hour;
              final bTime = b.day * 24 + b.hour;
              return aTime > bTime ? a : b;
            },
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
                  observation.cityId == cityId,
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
                  observation.goodId == goodId,
            )
            .toList();

    observations.sort((a, b) {
      if (a.day != b.day) {
        return a.day.compareTo(b.day);
      }

      return a.hour.compareTo(b.hour);
    });

    return observations;
  }

  static List<MarketObservation>
      observationsForCityAndGood({
    required PlayerState playerState,
    required String cityId,
    required String goodId,
  }) {
    final observations =
        playerState.ledger.observations
            .where(
              (observation) =>
                  observation.cityId == cityId &&
                  observation.goodId == goodId,
            )
            .toList();

    observations.sort((a, b) {
      if (a.day != b.day) {
        return a.day.compareTo(b.day);
      }

      return a.hour.compareTo(b.hour);
    });

    return observations;
  }
}