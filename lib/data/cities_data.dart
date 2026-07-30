import '../core/economy/animal_market_service.dart';
import '../core/economy/vehicle_market_service.dart';
import '../core/economy/equipment_market_service.dart';
import '../core/city/recruitment_service.dart';
import '../core/models/city.dart';
import '../core/models/industry.dart';
import '../core/models/market_good.dart';
import 'goods_data.dart';
import 'industry_data.dart';
import 'region_data.dart';

// GENERATED FILE - DO NOT EDIT

final farmingVillage = City(
  id: 'farmingVillage',
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
      size: 2,
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
      size: 2,
      inputDaysTarget: 5,
      cash: 25000,
      inventory: [],
    ),

  ],

  marketGoods: [
    MarketGood(
      good: grain,
      quantity: 0,
    ),

    MarketGood(
      good: bread,
      quantity: 180,
    ),

    MarketGood(
      good: water,
      quantity: 15,
    ),

    MarketGood(
      good: forage,
      quantity: 0,
    ),

    MarketGood(
      good: wood,
      quantity: 37,
    ),

    MarketGood(
      good: ironOre,
      quantity: 0,
    ),

    MarketGood(
      good: tools,
      quantity: 22,
    ),

    MarketGood(
      good: chair,
      quantity: 18,
    ),

    MarketGood(
      good: turnips,
      quantity: 184,
    ),

  ],

  animalMarketTier:
      AnimalMarketTier.major,

  vehicleMarketTier:
      VehicleMarketTier.major,

  equipmentMarketTier:
      EquipmentMarketTier.major,

  recruitmentMarketTier:
      RecruitmentMarketTier.major,

  hasVet:
      true,

  hasCartwright:
      true,

  hasDoctor:
      true,
);

final miningTown = City(
  id: 'miningTown',
  name: 'Mining Town',
  region: heartlands,
  x: 350,
  y: 50,
  population: 2000,

  industries: [
    Industry(
      type: mine,
      size: 2,
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
      size: 1,
      inputDaysTarget: 5,
      cash: 25000,
      inventory: [],
    ),

    Industry(
      type: toolmaker,
      size: 2,
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
      size: 2,
      inputDaysTarget: 3,
      cash: 25000,
      inventory: [],
    ),

  ],

  marketGoods: [
    MarketGood(
      good: grain,
      quantity: 0,
    ),

    MarketGood(
      good: bread,
      quantity: 345,
    ),

    MarketGood(
      good: water,
      quantity: 43,
    ),

    MarketGood(
      good: forage,
      quantity: 0,
    ),

    MarketGood(
      good: wood,
      quantity: 72,
    ),

    MarketGood(
      good: ironOre,
      quantity: 0,
    ),

    MarketGood(
      good: tools,
      quantity: 37,
    ),

    MarketGood(
      good: chair,
      quantity: 42,
    ),

    MarketGood(
      good: turnips,
      quantity: 447,
    ),

  ],

  animalMarketTier:
      AnimalMarketTier.major,

  vehicleMarketTier:
      VehicleMarketTier.major,

  equipmentMarketTier:
      EquipmentMarketTier.major,

  recruitmentMarketTier:
      RecruitmentMarketTier.major,

  hasVet:
      true,

  hasCartwright:
      true,

  hasDoctor:
      true,
);

final forestCamp = City(
  id: 'forestCamp',
  name: 'Forest Camp',
  region: heartlands,
  x: 600,
  y: 350,
  population: 600,

  industries: [
    Industry(
      type: loggingCamp,
      size: 2,
      inputDaysTarget: 7,
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
      type: well,
      size: 1,
      inputDaysTarget: 0,
      cash: 25000,
      inventory: [],
    ),

  ],

  marketGoods: [
    MarketGood(
      good: grain,
      quantity: 0,
    ),

    MarketGood(
      good: bread,
      quantity: 110,
    ),

    MarketGood(
      good: water,
      quantity: 11,
    ),

    MarketGood(
      good: forage,
      quantity: 0,
    ),

    MarketGood(
      good: wood,
      quantity: 25,
    ),

    MarketGood(
      good: ironOre,
      quantity: 0,
    ),

    MarketGood(
      good: tools,
      quantity: 11,
    ),

    MarketGood(
      good: chair,
      quantity: 12,
    ),

    MarketGood(
      good: turnips,
      quantity: 110,
    ),

  ],

  animalMarketTier:
      AnimalMarketTier.major,

  vehicleMarketTier:
      VehicleMarketTier.major,

  equipmentMarketTier:
      EquipmentMarketTier.major,

  recruitmentMarketTier:
      RecruitmentMarketTier.major,

  hasVet:
      true,

  hasCartwright:
      true,

  hasDoctor:
      true,
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

