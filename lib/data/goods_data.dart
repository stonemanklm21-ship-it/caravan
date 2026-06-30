import '../core/models/good.dart';

const grain = Good(
  name: 'Grain',
  basePrice: 10.0,
  weight: 0.2,
  caloriesPerUnit: 700,
);

const water = Good(
  name: 'Water',
  basePrice: 2.0,
  weight: 1.0,
  caloriesPerUnit: 0,
);

const forage = Good(
  name: 'Forage',
  basePrice: 1.0,
  weight: 1.0,
  caloriesPerUnit: 0,
);

const wood = Good(
  name: 'Wood',
  basePrice: 15.0,
  weight: 0.5,
  caloriesPerUnit: 0,
);

const ironOre = Good(
  name: 'Iron Ore',
  basePrice: 25.0,
  weight: 1.0,
  caloriesPerUnit: 0,
);

const goods = [
  grain,
  water,
  forage,
  wood,
  ironOre,
];