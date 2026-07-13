import '../core/models/weapon.dart';

const knife = Weapon(
  id: 'knife',
  name: 'Knife',
  accuracy: 9,
  damageDie: 5,
  weightKg: 0.3,
  basePrice: 1000, 
);

const club = Weapon(
  id: 'club',
  name: 'Club',
  accuracy: 8,
  damageDie: 8,
  weightKg: 1.5,
  basePrice: 1500
);

const spear = Weapon(
  id: 'spear',
  name: 'Spear',
  accuracy: 9,
  damageDie: 12,
  weightKg: 2.5,
  basePrice: 2000,
);

const sword = Weapon(
  id: 'sword',
  name: 'Sword',
  accuracy: 9,
  damageDie: 15,
  weightKg: 1.5,
  basePrice: 2500,
);

const battleAxe = Weapon(
  id: 'battle_axe',
  name: 'Battle Axe',
  accuracy: 7,
  damageDie: 20,
  weightKg: 3.0,
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