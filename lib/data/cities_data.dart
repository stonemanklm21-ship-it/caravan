import '../core/economy/animal_market_service.dart';
import '../core/economy/vehicle_market_service.dart';
import '../core/economy/equipment_market_service.dart';
import '../core/models/city.dart';
import '../core/models/industry.dart';
import '../core/models/market_good.dart';

import 'goods_data.dart';
import 'industry_data.dart';
import 'region_data.dart';

final farmingVillage = City(
  id: 'farming_village',
  name: 'Farming Village',
   region: heartlands,
  x: 100,
  y: 100,
  population: 1000,
  industries: [
    Industry(
      type: farm,
      size: 2,
      inputDaysTarget: 2,
      cash: 25000,
      inventory: [],
    ),
    Industry(
      type: well,
      size: 4,
      inputDaysTarget: 0,
      cash: 25000,
      inventory: [],
    ),
    Industry(
      type: gatheringCamp,
      size: 1,
      inputDaysTarget: 5,
      cash: 25000,
      inventory: [],
    ),
        Industry(
      type: turnipFarm,
      size: 4,
      inputDaysTarget: 5,
      cash: 25000,
      inventory: [],
    ),
  ],
  marketGoods: [
    MarketGood(good: grain, quantity: 120),
    MarketGood(good: bread, quantity: 250),
    MarketGood(good: water, quantity: 3000),
    MarketGood(good: forage, quantity: 150),
    MarketGood(good: wood, quantity: 60),
    MarketGood(good: ironOre, quantity: 20),
    MarketGood(good: tools, quantity: 3),
    MarketGood(good: chair, quantity: 1),
    MarketGood(good: turnips, quantity: 100)
  ],
  shopGoods: [],
  animalMarketTier: AnimalMarketTier.major,
  vehicleMarketTier: VehicleMarketTier.major,
  equipmentMarketTier: EquipmentMarketTier.major,
  hasVet: true,
  hasCartwright: true,
  hasDoctor: true,
);

final miningTown = City(
  id: 'mining_town',
  name: 'Mining Town',
   region: heartlands,
  x: 350,
  y: 50,
  population: 2000,
  industries: [
    Industry(
      type: mine,
      size: 4,
      inputDaysTarget: 14,
      cash: 25000,
      inventory: [],
    ),
    Industry(
      type: bakery,
      size: 2,
      inputDaysTarget: 3,
      cash: 25000,
      inventory: [],
    ),
    Industry(
      type: gatheringCamp,
      size: 8,
      inputDaysTarget: 5,
      cash: 25000,
      inventory: [],
    ),
    Industry(
      type: toolmaker,
      size: 4,
      inputDaysTarget: 5,
      cash: 25000,
      inventory: [],
    ),
    Industry(
      type: well,
      size: 2,
      inputDaysTarget: 0,
      cash: 25000,
      inventory: [],
    ),
    Industry(
      type: chairmaker,
      size: 4,
      inputDaysTarget: 3,
      cash: 25000,
      inventory: [],
    ),
  ],
  marketGoods: [
    MarketGood(good: grain, quantity: 40),
    MarketGood(good: bread, quantity: 300),
    MarketGood(good: water, quantity: 1000),
    MarketGood(good: forage, quantity: 600),
    MarketGood(good: wood, quantity: 50),
    MarketGood(good: ironOre, quantity: 150),
    MarketGood(good: tools, quantity: 10),
    MarketGood(good: chair, quantity: 1),
    MarketGood(good: turnips, quantity: 100)
  ],
  shopGoods: [],
  animalMarketTier: AnimalMarketTier.major,
  vehicleMarketTier: VehicleMarketTier.major,
  equipmentMarketTier: EquipmentMarketTier.major,
  hasVet: true,
  hasCartwright: true,
  hasDoctor: true,
);

final forestCamp = City(
  id: 'forest_camp',
  name: 'Forest Camp',
   region: heartlands,
  x: 600,
  y: 350,
  population: 600,
  industries: [
    Industry(
      type: loggingCamp,
      size: 4,
      inputDaysTarget: 7,
      cash: 25000,
      inventory: [],
    ),
    Industry(
      type: gatheringCamp,
      size: 2,
      inputDaysTarget: 5,
      cash: 25000,
      inventory: [],
    ),
    Industry(
      type: well,
      size: 1,
      inputDaysTarget: 0,
      cash: 25000,
      inventory: [],
    ),
  ],
  marketGoods: [
    MarketGood(good: grain, quantity: 30),
    MarketGood(good: bread, quantity: 250),
    MarketGood(good: water, quantity: 1000),
    MarketGood(good: forage, quantity: 180),
    MarketGood(good: wood, quantity: 180),
    MarketGood(good: ironOre, quantity: 10),
    MarketGood(good: tools, quantity: 3),
    MarketGood(good: chair, quantity: 1),
    MarketGood(good: turnips, quantity: 100)
  ],
  shopGoods: [],
  animalMarketTier: AnimalMarketTier.major,
  vehicleMarketTier: VehicleMarketTier.major,
  equipmentMarketTier: EquipmentMarketTier.major,
  hasVet: true,
  hasCartwright: true,
  hasDoctor: true,
);

final cities = [
  farmingVillage,
  miningTown,
  forestCamp,
];

final citiesById = {
  for (final city in cities)
    city.id: city,
};

City cityForId(
  String id,
) {
  return citiesById[id]!;
}