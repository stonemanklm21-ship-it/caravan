import 'game_balance.dart';
import '../core/models/industry_type.dart';
import 'goods_data.dart';

// GENERATED FILE - DO NOT EDIT

final bakery = IndustryType(
  id: 'bakery',
  name: 'Bakery',
  inputsPerSize: {
    grain:
        (GameBalance.outputForDemand(bread.populationDemandPerPersonPerDay)) *
        1,

    water:
        (GameBalance.outputForDemand(bread.populationDemandPerPersonPerDay)) *
        0.5,

  },
  outputsPerSize: {
    bread: GameBalance.outputForDemand(bread.populationDemandPerPersonPerDay),
  },
  operatingCostPerSizePerDay:
      6,
  workersPerSize:
      4,
  storagePerSize:
      1000,
);

final toolmaker = IndustryType(
  id: 'toolmaker',
  name: 'Toolmaker',
  inputsPerSize: {
    ironOre:
        (GameBalance.outputForDemand(tools.populationDemandPerPersonPerDay)) *
        1,

    wood:
        (GameBalance.outputForDemand(tools.populationDemandPerPersonPerDay)) *
        0.5,

  },
  outputsPerSize: {
    tools: GameBalance.outputForDemand(tools.populationDemandPerPersonPerDay),
  },
  operatingCostPerSizePerDay:
      8,
  workersPerSize:
      5,
  storagePerSize:
      1000,
);

final chairmaker = IndustryType(
  id: 'chairmaker',
  name: 'Chairmaker',
  inputsPerSize: {
    wood:
        (GameBalance.outputForDemand(chair.populationDemandPerPersonPerDay)) *
        1,

  },
  outputsPerSize: {
    chair: GameBalance.outputForDemand(chair.populationDemandPerPersonPerDay),
  },
  operatingCostPerSizePerDay:
      10,
  workersPerSize:
      6,
  storagePerSize:
      1000,
);

final turnipFarm = IndustryType(
  id: 'turnip_farm',
  name: 'Turnip Farm',
  inputsPerSize: {
    water:
        (GameBalance.outputForDemand(turnips.populationDemandPerPersonPerDay)) *
        0.5,

  },
  outputsPerSize: {
    turnips: GameBalance.outputForDemand(turnips.populationDemandPerPersonPerDay),
  },
  operatingCostPerSizePerDay:
      5,
  workersPerSize:
      5,
  storagePerSize:
      1000,
);

final farm = IndustryType(
  id: 'farm',
  name: 'Wheat Farm',
  inputsPerSize: {
    water:
        ((
  GameBalance.outputForDemand(
  bread.populationDemandPerPersonPerDay,
)

) * 1
) *
        0.5,

  },
  outputsPerSize: {
    grain: (
  GameBalance.outputForDemand(
  bread.populationDemandPerPersonPerDay,
)

) * 1
,
  },
  operatingCostPerSizePerDay:
      5,
  workersPerSize:
      5,
  storagePerSize:
      1000,
);

final well = IndustryType(
  id: 'well',
  name: 'Well',
  inputsPerSize: {
  },
  outputsPerSize: {
    water: (
  (
  GameBalance.outputForDemand(
  bread.populationDemandPerPersonPerDay,
)

) * 1

) * 0.5
 + (
  (
  GameBalance.outputForDemand(
  tools.populationDemandPerPersonPerDay,
)

) * 1

) * 0.25
 + (
  GameBalance.outputForDemand(
  bread.populationDemandPerPersonPerDay,
)

) * 0.5
 + (
  GameBalance.outputForDemand(
  turnips.populationDemandPerPersonPerDay,
)

) * 0.5
,
  },
  operatingCostPerSizePerDay:
      2,
  workersPerSize:
      2,
  storagePerSize:
      1000,
);

final gatheringCamp = IndustryType(
  id: 'gathering_camp',
  name: 'Gathering Camp',
  inputsPerSize: {
  },
  outputsPerSize: {
    forage: (
  (
  GameBalance.outputForDemand(
  tools.populationDemandPerPersonPerDay,
)

) * 0.5
 + (
  GameBalance.outputForDemand(
  chair.populationDemandPerPersonPerDay,
)

) * 1

) * 0.25
 + (
  (
  GameBalance.outputForDemand(
  tools.populationDemandPerPersonPerDay,
)

) * 1

) * 0.25
,
  },
  operatingCostPerSizePerDay:
      3,
  workersPerSize:
      4,
  storagePerSize:
      1000,
);

final loggingCamp = IndustryType(
  id: 'logging_camp',
  name: 'Logging Camp',
  inputsPerSize: {
    forage:
        ((
  GameBalance.outputForDemand(
  tools.populationDemandPerPersonPerDay,
)

) * 0.5
 + (
  GameBalance.outputForDemand(
  chair.populationDemandPerPersonPerDay,
)

) * 1
) *
        0.25,

  },
  outputsPerSize: {
    wood: (
  GameBalance.outputForDemand(
  tools.populationDemandPerPersonPerDay,
)

) * 0.5
 + (
  GameBalance.outputForDemand(
  chair.populationDemandPerPersonPerDay,
)

) * 1
,
  },
  operatingCostPerSizePerDay:
      4,
  workersPerSize:
      6,
  storagePerSize:
      1000,
);

final mine = IndustryType(
  id: 'mine',
  name: 'Mine',
  inputsPerSize: {
    water:
        ((
  GameBalance.outputForDemand(
  tools.populationDemandPerPersonPerDay,
)

) * 1
) *
        0.25,

    forage:
        ((
  GameBalance.outputForDemand(
  tools.populationDemandPerPersonPerDay,
)

) * 1
) *
        0.25,

  },
  outputsPerSize: {
    ironOre: (
  GameBalance.outputForDemand(
  tools.populationDemandPerPersonPerDay,
)

) * 1
,
  },
  operatingCostPerSizePerDay:
      10,
  workersPerSize:
      10,
  storagePerSize:
      1000,
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

