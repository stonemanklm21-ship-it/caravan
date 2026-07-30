import '../models/good.dart';

class TradeAnalytics {
  static final Map<String, double> produced = {};
  static final Map<String, double> consumed = {};
  static final Map<String, double> unmetDemand = {};
  static final Map<String, double> transported = {};
  static final Map<String, double>    desiredConsumption = {};

  static void recordProduced(
    Good good,
    double quantity,
  ) {
    produced.update(
      good.id,
      (v) => v + quantity,
      ifAbsent: () => quantity,
    );
  }

  static void recordConsumed(
    Good good,
    double quantity,
  ) {
    consumed.update(
      good.id,
      (v) => v + quantity,
      ifAbsent: () => quantity,
    );
  }

  static void recordUnmetDemand(
    Good good,
    double quantity,
  ) {
    unmetDemand.update(
      good.id,
      (v) => v + quantity,
      ifAbsent: () => quantity,
    );
  }

  static void recordTransported(
    Good good,
    double quantity,
  ) {
    transported.update(
      good.id,
      (v) => v + quantity,
      ifAbsent: () => quantity,
    );
  }

static void recordDesiredConsumption(
  Good good,
  double quantity,
) {
  desiredConsumption.update(
    good.id,
    (v) => v + quantity,
    ifAbsent: () => quantity,
  );
}

static void reset() {
  produced.clear();
  consumed.clear();
  unmetDemand.clear();
  transported.clear();
  desiredConsumption.clear();
}
}