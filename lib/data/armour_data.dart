import '../core/models/armour.dart';

// GENERATED FILE - DO NOT EDIT

const paddedArmour = Armour(
  id: 'padded_armour',
  name: 'Padded Armour',
  protection: 5,
  weightKg: 0.6,
  basePrice: 1000,
);


const leatherArmour = Armour(
  id: 'leather_armour',
  name: 'Leather Armour',
  protection: 8,
  weightKg: 0.8,
  basePrice: 1500,
);


const chainmail = Armour(
  id: 'chainmail',
  name: 'Chainmail',
  protection: 12,
  weightKg: 1,
  basePrice: 2500,
);


const plateArmour = Armour(
  id: 'plate_armour',
  name: 'Plate Armour',
  protection: 15,
  weightKg: 1.2,
  basePrice: 5000,
);


const armours = <Armour>[
  paddedArmour,
  leatherArmour,
  chainmail,
  plateArmour,
];

Armour armourForId(
  String id,
) {
  return armours.firstWhere(
    (armour) => armour.id == id,
  );
}

