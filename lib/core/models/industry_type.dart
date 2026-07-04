import 'good.dart';

class IndustryType {
  final String id;
  final String name;

  final Map<Good, double> inputsPerSize;
  final Map<Good, double> outputsPerSize;

  final double operatingCostPerSizePerDay;
  final double workersPerSize;
  final double storagePerSize;

  const IndustryType({
    required this.id,
    required this.name,
    required this.inputsPerSize,
    required this.outputsPerSize,
    required this.operatingCostPerSizePerDay,
    required this.workersPerSize,
    required this.storagePerSize,
  });
}