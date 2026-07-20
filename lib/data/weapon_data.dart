import '../core/models/weapon.dart';

// GENERATED FILE - DO NOT EDIT

const knife = Weapon(
  id: 'knife',
  name: 'Knife',
  accuracy: 88,
  damageDie: 5,
  weightKg: 0.3,
  basePrice: 1000,
);


const club = Weapon(
  id: 'club',
  name: 'Club',
  accuracy: 96,
  damageDie: 3,
  weightKg: 0.4,
  basePrice: 1500,
);


const spear = Weapon(
  id: 'spear',
  name: 'Spear',
  accuracy: 92,
  damageDie: 12,
  weightKg: 0.6,
  basePrice: 2000,
);


const sword = Weapon(
  id: 'sword',
  name: 'Sword',
  accuracy: 85,
  damageDie: 15,
  weightKg: 0.8,
  basePrice: 2500,
);


const battleAxe = Weapon(
  id: 'battle_axe',
  name: 'Battle Axe',
  accuracy: 75,
  damageDie: 20,
  weightKg: 1.2,
  basePrice: 5000,
);


const weapons = <Weapon>[
  knife,
  club,
  spear,
  sword,
  battleAxe,
];

Weapon weaponForId(
  String id,
) {
  return weapons.firstWhere(
    (weapon) => weapon.id == id,
  );
}

