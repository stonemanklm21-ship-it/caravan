import 'package:flutter/material.dart';

import '../data/armour_data.dart';
import '../data/helmet_data.dart';
import '../data/weapon_data.dart';

import '../core/models/caravan.dart';
import '../core/models/character.dart';

class CharacterScreen extends StatefulWidget {
  final Character character;
  final Caravan caravan;

  const CharacterScreen({
    super.key,
    required this.character,
    required this.caravan,
  });

  @override
  State<CharacterScreen> createState() =>
      _CharacterScreenState();
}

class _CharacterScreenState
    extends State<CharacterScreen> {
  Character get character =>
      widget.character;

  Caravan get caravan =>
      widget.caravan;

  Future<void> _equipWeapon() async {
    final weapon = await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            'Equip Weapon',
          ),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(
                  context,
                  null,
                );
              },
              child: const Text(
                'None',
              ),
            ),
            ...caravan.weapons.map(
              (weapon) =>
                  SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(
                    context,
                    weapon,
                  );
                },
                child: Text(
                  weapon.name,
                ),
              ),
            ),
          ],
        );
      },
    );

    final oldWeapon =
        character.weapon;

    setState(() {
      if (oldWeapon != null) {
        caravan.weapons.add(
          oldWeapon,
        );
      }

      if (weapon != null) {
        caravan.weapons.remove(
          weapon,
        );
      }

      character.weapon = weapon;

      if (character
              .availableCargoCapacityKg <
          0) {
        character.weapon = oldWeapon;

        if (weapon != null) {
          caravan.weapons.add(
            weapon,
          );
        }

        if (oldWeapon != null) {
          caravan.weapons.remove(
            oldWeapon,
          );
        }

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Not enough carrying capacity.',
            ),
          ),
        );
      }
    });
  }

  Future<void> _equipArmour() async {
    final armour = await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            'Equip Armour',
          ),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(
                  context,
                  null,
                );
              },
              child: const Text(
                'None',
              ),
            ),
            ...caravan.armours.map(
              (armour) =>
                  SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(
                    context,
                    armour,
                  );
                },
                child: Text(
                  armour.name,
                ),
              ),
            ),
          ],
        );
      },
    );

    final oldArmour =
        character.armour;

    setState(() {
      if (oldArmour != null) {
        caravan.armours.add(
          oldArmour,
        );
      }

      if (armour != null) {
        caravan.armours.remove(
          armour,
        );
      }

      character.armour = armour;

      if (character
              .availableCargoCapacityKg <
          0) {
        character.armour =
            oldArmour;

        if (armour != null) {
          caravan.armours.add(
            armour,
          );
        }

        if (oldArmour != null) {
          caravan.armours.remove(
            oldArmour,
          );
        }

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Not enough carrying capacity.',
            ),
          ),
        );
      }
    });
  }

  Future<void> _equipHelmet() async {
    final helmet = await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            'Equip Helmet',
          ),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(
                  context,
                  null,
                );
              },
              child: const Text(
                'None',
              ),
            ),
            ...caravan.helmets.map(
              (helmet) =>
                  SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(
                    context,
                    helmet,
                  );
                },
                child: Text(
                  helmet.name,
                ),
              ),
            ),
          ],
        );
      },
    );

    final oldHelmet =
        character.helmet;

    setState(() {
      if (oldHelmet != null) {
        caravan.helmets.add(
          oldHelmet,
        );
      }

      if (helmet != null) {
        caravan.helmets.remove(
          helmet,
        );
      }

      character.helmet = helmet;

      if (character
              .availableCargoCapacityKg <
          0) {
        character.helmet =
            oldHelmet;

        if (helmet != null) {
          caravan.helmets.add(
            helmet,
          );
        }

        if (oldHelmet != null) {
          caravan.helmets.remove(
            oldHelmet,
          );
        }

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Not enough carrying capacity.',
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          character.name,
        ),
      ),
      body: ListView(
        padding:
            const EdgeInsets.all(16),
        children: [
          Text(
            character.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 16,
          ),

          const Text(
            'General',
            style: TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          Text(
            'Age: ${character.ageYears}',
          ),

          Text(
            'HP: ${character.hp.toStringAsFixed(0)} / ${character.maxHp.toStringAsFixed(0)}',
          ),

          const SizedBox(
            height: 16,
          ),

          const Text(
            'Skills',
            style: TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          Text(
            'Doctor: ${character.doctorSkill}',
          ),

          Text(
            'Vet: ${character.vetSkill}',
          ),

          Text(
            'Mechanic: ${character.mechanicSkill}',
          ),

          Text(
            'Scout: ${character.scoutSkill}',
          ),

          Text(
            'Combat: ${character.combatSkill}',
          ),

          const SizedBox(
            height: 16,
          ),

          const Text(
            'Equipment',
            style: TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          Wrap(
            spacing: 8,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    caravan.weapons.add(
                      sword,
                    );
                  });
                },
                child: const Text(
                  '+ Sword',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    caravan.armours.add(
                      leatherArmour,
                    );
                  });
                },
                child: const Text(
                  '+ Armour',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    caravan.helmets.add(
                      ironHelmet,
                    );
                  });
                },
                child: const Text(
                  '+ Helmet',
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 12,
          ),

          Row(
            children: [
              Expanded(
                child: Text(
                  'Weapon: ${character.weapon?.name ?? 'None'}',
                ),
              ),
              ElevatedButton(
                onPressed:
                    _equipWeapon,
                child: const Text(
                  'Equip',
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 8,
          ),

          Row(
            children: [
              Expanded(
                child: Text(
                  'Armour: ${character.armour?.name ?? 'None'}',
                ),
              ),
              ElevatedButton(
                onPressed:
                    _equipArmour,
                child: const Text(
                  'Equip',
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 8,
          ),

          Row(
            children: [
              Expanded(
                child: Text(
                  'Helmet: ${character.helmet?.name ?? 'None'}',
                ),
              ),
              ElevatedButton(
                onPressed:
                    _equipHelmet,
                child: const Text(
                  'Equip',
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 16,
          ),

          const Text(
            'Combat Stats',
            style: TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          Text(
            'Accuracy: ${character.accuracy}',
          ),

          Text(
            'Damage: d${character.damageDie}',
          ),

          Text(
            'Protection: ${character.protection}',
          ),

          const SizedBox(
            height: 16,
          ),

          const Text(
            'Carrying Capacity',
            style: TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          Text(
            'Base Capacity: '
            '${character.cargoCapacityKg.toStringAsFixed(1)}kg',
          ),

          Text(
            'Equipment Weight: '
            '${character.equipmentWeightKg.toStringAsFixed(1)}kg',
          ),

          Text(
            'Available Capacity: '
            '${character.availableCargoCapacityKg.toStringAsFixed(1)}kg',
          ),
        ],
      ),
    );
  }
}