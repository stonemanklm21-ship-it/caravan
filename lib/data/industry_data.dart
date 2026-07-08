import '../core/models/industry_type.dart';
import 'goods_data.dart';

final farm = IndustryType(
  id: 'farm',
  name: 'Farm',
  inputsPerSize: {
    water: 10,
  },
  outputsPerSize: {
    grain: 20,
  },
  operatingCostPerSizePerDay: 5,
  workersPerSize: 5,
  storagePerSize: 100,
);

final well = IndustryType(
  id: 'well',
  name: 'Well',
  inputsPerSize: {},
  outputsPerSize: {
    water: 30,
  },
  operatingCostPerSizePerDay: 2,
  workersPerSize: 2,
  storagePerSize: 100,
);

final gatheringCamp = IndustryType(
  id: 'gathering_camp',
  name: 'Gathering Camp',
  inputsPerSize: {},
  outputsPerSize: {
    forage: 20,
  },
  operatingCostPerSizePerDay: 3,
  workersPerSize: 4,
  storagePerSize: 300,
);

final loggingCamp = IndustryType(
  id: 'logging_camp',
  name: 'Logging Camp',
  inputsPerSize: {
    forage: 5,
  },
  outputsPerSize: {
    wood: 10,
  },
  operatingCostPerSizePerDay: 4,
  workersPerSize: 6,
  storagePerSize: 100,
);

final mine = IndustryType(
  id: 'mine',
  name: 'Mine',
  inputsPerSize: {
    water: 5,
    forage: 5,
  },
  outputsPerSize: {
    ironOre: 10,
  },
  operatingCostPerSizePerDay: 10,
  workersPerSize: 10,
  storagePerSize: 100,
);

final bakery = IndustryType(
  id: 'bakery',
  name: 'Bakery',
  inputsPerSize: {
    grain: 20,
    water: 20,
  },
  outputsPerSize: {
    bread: 20,
  },
  operatingCostPerSizePerDay: 6,
  workersPerSize: 4,
  storagePerSize: 100,
);

final toolmaker = IndustryType(
  id: 'toolmaker',
  name: 'Toolmaker',
  inputsPerSize: {
    ironOre: 10,
    wood: 5,
  },
  outputsPerSize: {
    tools: 5,
  },
  operatingCostPerSizePerDay: 8,
  workersPerSize: 5,
  storagePerSize: 100,
);

final chairmaker = IndustryType(
  id: 'chairmaker',
  name: 'Chairmaker',
  inputsPerSize: {
    wood: 10,
  },
  outputsPerSize: {
    chair: 5,
  },
  operatingCostPerSizePerDay: 10,
  workersPerSize: 6,
  storagePerSize: 100,
);

final industryTypes = [
  farm,
  well,
  gatheringCamp,
  loggingCamp,
  mine,
  bakery,
  toolmaker,
  chairmaker,
];

final industryTypesById = {
  for (final type in industryTypes)
    type.id: type,
};

IndustryType industryTypeForId(
  String id,
) {
  return industryTypesById[id]!;
}