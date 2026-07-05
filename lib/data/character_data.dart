import '../core/models/character.dart';

final defaultPlayer = Character(
  id: 'player',
  name: 'Player',
  ageYears: 30,
  wagePerDay: 0,
  hp: 100,
  maxHp: 100,
  cargoCapacityKg: 10,
  caloriesPerDay: 2500,
  waterPerDay: 3,
);

final defaultNpc = Character(
  id: 'npc',
  name: 'Trader',
  ageYears: 35,
  wagePerDay: 5,
  cargoCapacityKg: 10,
  caloriesPerDay: 2500,
  waterPerDay: 3,
  hp: 100,
  maxHp: 100,
);