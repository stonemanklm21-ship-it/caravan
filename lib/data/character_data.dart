import '../core/models/character.dart';
import '../core/models/portrait_dna.dart';
import 'package:flutter/material.dart';


final defaultPlayer = Character(
  id: 'player',
  name: 'Player',
  ageYears: 30,
  weightKg: 75,
  wagePerDay: 0,
  strength: 5,
  endurance: 5,
  life: 10,
  fortitude: 5,
  hp: 100,
  doctorXp: 50,
  vetXp: 50,
  mechanicXp: 50,
  scoutXp: 50,
  combatXp: 50,
);

final defaultNpc = Character(
  id: 'npc',
  name: 'Trader',
  ageYears: 35,
  weightKg: 75,
  wagePerDay: 5,
  strength: 5,
  endurance: 5,
  life: 10,
  fortitude: 5,
  hp: 100,
  doctorXp: 2550,
  vetXp: 2550,
  mechanicXp: 2550,
  scoutXp: 2550,
  combatXp: 2550,
);

final miningMerchant = Character(
  id: 'miningMerchant',
  name: 'Merchant Captain Trenton',
  cityId: 'farmingVillage',
  portrait: const PortraitDna(
    headAssetOverride:
        'assets/portraits/trenton_head.png',
    eyeAssetOverride:
        'assets/portraits/trenton_eyes.png',
    hairStyle: 6,
    mouthStyle: 1,
    extraLayers: [
      'assets/portraits/trenton_eyepatch.png',
    ],
    skinColor: Color(0xFFC68642),
    hairColor: Color(0xFF2C1B18),
    mouthColor: Color(0xFFA35C58),
  ),
  ageYears: 42,
  weightKg: 80,
  wagePerDay: 10,
  strength: 5,
  endurance: 5,
  life: 10,
  fortitude: 5,
  hp: 100,
  doctorXp: 2550,
  vetXp: 2550,
  mechanicXp: 2550,
  scoutXp: 2550,
  combatXp: 2550,
);

final forestForeman = Character(
  id: 'forestForeman',
  name: 'Forest Foreman',
  cityId: 'forestCamp',
  ageYears: 50,
  weightKg: 85,
  wagePerDay: 10,
  strength: 5,
  endurance: 5,
  life: 10,
  fortitude: 5,
  hp: 100,
  doctorXp: 2550,
  vetXp: 2550,
  mechanicXp: 2550,
  scoutXp: 2550,
  combatXp: 2550,
);

final ladyVera = Character(
  id: 'ladyVera',
  name: 'Lady Vera',
  cityId: 'capital',
  portrait: const PortraitDna(
    headAssetOverride:
        'assets/portraits/lady_vera_head.png',
    hairAssetOverride:
        'assets/portraits/lady_vera_hair.png',
    eyeStyle: 1,
    mouthStyle: 2,
    extraLayers: [
      'assets/portraits/lady_vera_crown.png',
      'assets/portraits/lady_vera_jewellery.png',
    ],
    skinColor: Color(0xFFFFE0BD),
    hairColor: Color(0xFFD6B370),
    mouthColor: Color(0xFFE0948D),
  ),
  ageYears: 37,
  weightKg: 65,
  wagePerDay: 0,
  strength: 0,
  endurance: 5,
  life: 8,
  fortitude: 6,
  hp: 90,
  doctorXp: 2550,
  vetXp: 2550,
  mechanicXp: 2550,
  scoutXp: 2550,
  combatXp: 2550,
);