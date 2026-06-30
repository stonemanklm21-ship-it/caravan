import '../core/models/city.dart';
import '../core/models/city_specialisation.dart';
import '../core/models/market_good.dart';
import 'goods_data.dart';

final farmingVillage = City(
  name: 'Farming Village',
  specialisation: CitySpecialisation.farming,
  x: 100,
  y: 100,
  marketGoods: [
    MarketGood(
      good: grain,
      supply: 120,
      demand: 40,
      productionPerDay: 20,
      consumptionPerDay: 5,
    ),
    MarketGood(
      good: water,
      supply: 200,
      demand: 50,
      productionPerDay: 30,
      consumptionPerDay: 10,
    ),
    MarketGood(
      good: forage,
      supply: 150,
      demand: 40,
      productionPerDay: 15,
      consumptionPerDay: 5,
    ),
    MarketGood(
      good: wood,
      supply: 60,
      demand: 80,
      productionPerDay: 8,
      consumptionPerDay: 3,
    ),
    MarketGood(
      good: ironOre,
      supply: 20,
      demand: 100,
      productionPerDay: 1,
      consumptionPerDay: 2,
    ),
  ],
);

final miningTown = City(
  name: 'Mining Town',
  specialisation: CitySpecialisation.mining,
  x: 400,
  y: 250,
  marketGoods: [
    MarketGood(
      good: grain,
      supply: 40,
      demand: 120,
      productionPerDay: 2,
      consumptionPerDay: 10,
    ),
    MarketGood(
      good: water,
      supply: 80,
      demand: 150,
      productionPerDay: 8,
      consumptionPerDay: 12,
    ),
    MarketGood(
      good: forage,
      supply: 60,
      demand: 120,
      productionPerDay: 3,
      consumptionPerDay: 8,
    ),
    MarketGood(
      good: wood,
      supply: 50,
      demand: 80,
      productionPerDay: 2,
      consumptionPerDay: 4,
    ),
    MarketGood(
      good: ironOre,
      supply: 150,
      demand: 40,
      productionPerDay: 20,
      consumptionPerDay: 5,
    ),
  ],
);

final cities = [
  farmingVillage,
  miningTown,
];