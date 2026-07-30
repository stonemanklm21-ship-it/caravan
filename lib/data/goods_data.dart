import '../core/models/good.dart';

const grain = Good(
  id: 'grain',
  variableName: 'grain',
  name: 'Grain',
  priceFloor: 0.2,
  priceCeiling: 10,
  weight: 0.2,
  caloriesPerUnit: 0,
  populationDemandPerPersonPerDay: 0,
);

const bread = Good(
  id: 'bread',
  variableName: 'bread',
  name: 'Bread',
  priceFloor: 10,
  priceCeiling: 50,
  weight: 0.2,
  caloriesPerUnit: 1200,
  populationDemandPerPersonPerDay: 0.1,
);

const water = Good(
  id: 'water',
  variableName: 'water',
  name: 'Water',
  priceFloor: 1,
  priceCeiling: 10,
  weight: 1,
  waterPerUnit: 1,
  populationDemandPerPersonPerDay: 0.01,
);

const forage = Good(
  id: 'forage',
  variableName: 'forage',
  name: 'Forage',
  priceFloor: 0.5,
  priceCeiling: 15,
  weight: 1,
  populationDemandPerPersonPerDay: 0,
);

const wood = Good(
  id: 'wood',
  variableName: 'wood',
  name: 'Wood',
  priceFloor: 10,
  priceCeiling: 50,
  weight: 0.5,
  populationDemandPerPersonPerDay: 0.02,
);

const ironOre = Good(
  id: 'iron_ore',
  variableName: 'ironOre',
  name: 'Iron Ore',
  priceFloor: 20,
  priceCeiling: 100,
  weight: 1,
  populationDemandPerPersonPerDay: 0,
);

const tools = Good(
  id: 'tools',
  variableName: 'tools',
  name: 'Tools',
  weight: 1,
  priceFloor: 20,
  priceCeiling: 250,
  populationDemandPerPersonPerDay: 0.01,
);

const chair = Good(
  id: 'chair',
  variableName: 'chair',
  name: 'Chair',
  weight: 1,
  priceFloor: 50,
  priceCeiling: 500,
  populationDemandPerPersonPerDay: 0.01,
);

const turnips = Good(
  id: 'turnips',
  variableName: 'turnips',
  name: 'Turnips',
  weight: 0.3,
  priceFloor: 2,
  priceCeiling: 15,
  caloriesPerUnit: 500,
  populationDemandPerPersonPerDay: 0.1,
);

const goods = [
  grain,
  bread,
  water,
  forage,
  wood,
  ironOre,
  tools,
  chair,
  turnips,
];

final goodsById = {
  for (final good in goods)
    good.id: good,
};

Good goodForId(
  String id,
) {
  return goodsById[id]!;
}