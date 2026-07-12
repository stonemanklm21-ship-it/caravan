import '../core/models/good.dart';

const grain = Good(
  id: 'grain',
  name: 'Grain',
  priceFloor: 0.2,
  priceCeiling: 5,
  weight: 0.2,
  caloriesPerUnit: 0,
);

const bread = Good(
  id: 'bread',
  name: 'Bread',
  priceFloor: 10,
  priceCeiling: 40,
  weight: 0.5,
  caloriesPerUnit: 1200,
);

const water = Good(
  id: 'water',
  name: 'Water',
  priceFloor: 1,
  priceCeiling: 10,
  weight: 1,
  waterPerUnit: 1,
);

const forage = Good(
  id: 'forage',
  name: 'Forage',
  priceFloor: 0.5,
  priceCeiling: 15,
  weight: 1,
);

const wood = Good(
  id: 'wood',
  name: 'Wood',
  priceFloor: 10,
  priceCeiling: 50,
  weight: 0.5,
);

const ironOre = Good(
  id: 'iron_ore',
  name: 'Iron Ore',
  priceFloor: 20,
  priceCeiling: 100,
  weight: 1,
);

const tools = Good(
  id: 'tools',
  name: 'Tools',
  weight: 1,
  priceFloor: 20,
  priceCeiling: 250,
);

const chair = Good(
  id: 'chair',
  name: 'Chair',
  weight: 1.5,
  priceFloor: 50,
  priceCeiling: 500,
);

const turnips = Good(
  id: 'turnips',
  name: 'Turnips',
  weight: 0.3,
  priceFloor: 5,
  priceCeiling: 15,
  caloriesPerUnit: 500,
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