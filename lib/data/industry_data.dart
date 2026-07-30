import 'game_balance.dart';
import '../core/models/industry_type.dart';
import 'goods_data.dart';

final bakery = IndustryType(
  id: 'bakery',
  name: 'Bakery',
  inputsPerSize: {
    grain: GameBalance.outputForDemand(
      GameBalance.breadDemandPerPersonPerDay,
    ),
    water: 100,
  },
  outputsPerSize: {
    bread: GameBalance.outputForDemand(
      GameBalance.breadDemandPerPersonPerDay,
    ),
  },
  operatingCostPerSizePerDay: 6,
  workersPerSize: 4,
  storagePerSize: 100,
);

final turnipFarm = IndustryType(
  id: 'turnip_farm',
  name: 'Turnip Farm',
  inputsPerSize: {
    water: 100,
  },
  outputsPerSize: {
    turnips: GameBalance.outputForDemand(
      GameBalance.turnipDemandPerPersonPerDay,
    ),
  },
  operatingCostPerSizePerDay: 5,
  workersPerSize: 5,
  storagePerSize: 100,
);

final toolmaker = IndustryType(
  id: 'toolmaker',
  name: 'Toolmaker',
  inputsPerSize: {
    ironOre: GameBalance.outputForDemand(
      GameBalance.toolsDemandPerPersonPerDay,
    ),
    wood:
        GameBalance.outputForDemand(
              GameBalance.toolsDemandPerPersonPerDay,
            ) /
            2,
  },
  outputsPerSize: {
    tools: GameBalance.outputForDemand(
      GameBalance.toolsDemandPerPersonPerDay,
    ),
  },
  operatingCostPerSizePerDay: 8,
  workersPerSize: 5,
  storagePerSize: 100,
);

final chairmaker = IndustryType(
  id: 'chairmaker',
  name: 'Chairmaker',
  inputsPerSize: {
    wood: GameBalance.outputForDemand(
      GameBalance.chairDemandPerPersonPerDay,
    ),
  },
  outputsPerSize: {
    chair: GameBalance.outputForDemand(
      GameBalance.chairDemandPerPersonPerDay,
    ),
  },
  operatingCostPerSizePerDay: 10,
  workersPerSize: 6,
  storagePerSize: 100,
);

final farm = IndustryType(
  id: 'farm',
  name: 'Farm',
  inputsPerSize: {
    water: 100,
  },
  outputsPerSize: {
    grain: bakery.inputsPerSize[grain]!,
  },
  operatingCostPerSizePerDay: 5,
  workersPerSize: 5,
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
    ironOre: toolmaker.inputsPerSize[ironOre]!,
  },
  operatingCostPerSizePerDay: 10,
  workersPerSize: 10,
  storagePerSize: 100,
);

final loggingCamp = IndustryType(
  id: 'logging_camp',
  name: 'Logging Camp',
  inputsPerSize: {
    forage: 5,
  },
  outputsPerSize: {
    wood:
        toolmaker.inputsPerSize[wood]! +
        chairmaker.inputsPerSize[wood]!,
  },
  operatingCostPerSizePerDay: 4,
  workersPerSize: 6,
  storagePerSize: 100,
);

final well = IndustryType(
  id: 'well',
  name: 'Well',
  inputsPerSize: {},
  outputsPerSize: {
    water: 300,
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

final industryTypes = [
  farm,
  well,
  gatheringCamp,
  loggingCamp,
  mine,
  bakery,
  toolmaker,
  chairmaker,
  turnipFarm,
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