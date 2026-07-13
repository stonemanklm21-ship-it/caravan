import '../core/models/armour.dart';

const paddedArmour = Armour(
  id: 'padded_armour',
  name: 'Padded Armour',
  protection: 1,
  weightKg: 4,
  basePrice: 1000,
);

const leatherArmour = Armour(
  id: 'leather_armour',
  name: 'Leather Armour',
  protection: 2,
  weightKg: 8,
  basePrice: 1500,
);

const chainmail = Armour(
  id: 'chainmail',
  name: 'Chainmail',
  protection: 4,
  weightKg: 18,
  basePrice: 2500,
);

const plateArmour = Armour(
  id: 'plate_armour',
  name: 'Plate Armour',
  protection: 6,
  weightKg: 30,
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