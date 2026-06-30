import '../core/models/caravan_component.dart';

const player = CaravanComponent(
  name: 'Player',
  type: CaravanComponentType.person,
  cargoCapacityKg: 10,
  travelSpeed: 1.0,
  purchasePrice: 0,
  caloriesPerDay: 2500,
  waterPerDay: 3,
  foragePerDay: 0,
  fuelPerDay: 0,
);

const donkey = CaravanComponent(
  name: 'Donkey',
  type: CaravanComponentType.packAnimal,
  cargoCapacityKg: 50,
  travelSpeed: 0.8,
  purchasePrice: 50,
  caloriesPerDay: 0,
  waterPerDay: 5,
  foragePerDay: 8,
  fuelPerDay: 0,
);

const horse = CaravanComponent(
  name: 'Horse',
  type: CaravanComponentType.packAnimal,
  cargoCapacityKg: 40,
  travelSpeed: 1.5,
  purchasePrice: 150,
  caloriesPerDay: 0,
  waterPerDay: 8,
  foragePerDay: 10,
  fuelPerDay: 0,
);

const cart = CaravanComponent(
  name: 'Cart',
  type: CaravanComponentType.vehicle,
  cargoCapacityKg: 100,
  travelSpeed: 0.4,
  purchasePrice: 200,
  caloriesPerDay: 0,
  waterPerDay: 0,
  foragePerDay: 0,
  fuelPerDay: 0,
);

const components = [
  player,
  donkey,
  horse,
  cart,
];