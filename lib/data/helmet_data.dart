import '../core/models/helmet.dart';

// GENERATED FILE - DO NOT EDIT

const clothCap = Helmet(
  id: 'cloth_cap',
  name: 'Cloth Cap',
  protection: 2,
  weightKg: 0.1,
  basePrice: 1000,
);


const leatherCap = Helmet(
  id: 'leather_cap',
  name: 'Leather Cap',
  protection: 8,
  weightKg: 0.2,
  basePrice: 1500,
);


const ironHelmet = Helmet(
  id: 'iron_helmet',
  name: 'Iron Helmet',
  protection: 14,
  weightKg: 0.5,
  basePrice: 1750,
);


const greatHelm = Helmet(
  id: 'great_helm',
  name: 'Great Helm',
  protection: 22,
  weightKg: 0.8,
  basePrice: 2500,
);


const helmets = <Helmet>[
  clothCap,
  leatherCap,
  ironHelmet,
  greatHelm,
];

Helmet helmetForId(
  String id,
) {
  return helmets.firstWhere(
    (helmet) => helmet.id == id,
  );
}

