import 'package:flutter/material.dart';

import '../core/combat/combat_result.dart';
import '../core/combat/loot_service.dart';
import '../core/combat/selected_loot.dart';
import '../core/models/caravan.dart';

class CombatResultScreen extends StatefulWidget {
  final CombatResult result;
  final Caravan caravan;

  const CombatResultScreen({
    super.key,
    required this.result,
    required this.caravan,
  });

  @override
  State<CombatResultScreen> createState() =>
      _CombatResultScreenState();
}

class _CombatResultScreenState
    extends State<CombatResultScreen> {
  final Set<dynamic> selected = {};

  @override
  void initState() {
    super.initState();

    selected.addAll(widget.result.loot.inventory);
    selected.addAll(widget.result.loot.weapons);
    selected.addAll(widget.result.loot.armours);
    selected.addAll(widget.result.loot.helmets);
    selected.addAll(widget.result.loot.animals);
    selected.addAll(widget.result.loot.vehicles);
  }

  Widget _checkboxTile({
    required dynamic item,
    required String label,
  }) {
    return CheckboxListTile(
      dense: true,
      value: selected.contains(item),
      title: Text(label),
      onChanged: (value) {
        setState(() {
          if (value == true) {
            selected.add(item);
          } else {
            selected.remove(item);
          }
        });
      },
    );
  }

  void _takeAll() {
    LootService.takeAll(
      caravan: widget.caravan,
      loot: widget.result.loot,
    );

    Navigator.pop(context);
  }

  void _takeSelected() {
    LootService.takeSelected(
      caravan: widget.caravan,
      loot: SelectedLoot(
        inventory: widget.result.loot.inventory
            .where(selected.contains)
            .toList(),
        weapons: widget.result.loot.weapons
            .where(selected.contains)
            .toList(),
        armours: widget.result.loot.armours
            .where(selected.contains)
            .toList(),
        helmets: widget.result.loot.helmets
            .where(selected.contains)
            .toList(),
        animals: widget.result.loot.animals
            .where(selected.contains)
            .toList(),
        vehicles: widget.result.loot.vehicles
            .where(selected.contains)
            .toList(),
      ),
    );

    Navigator.pop(context);
  }

  void _continue() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Combat Result',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                widget.result.victory
                    ? 'VICTORY'
                    : 'DEFEAT',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight:
                      FontWeight.bold,
                  color:
                      widget.result.victory
                          ? Colors.green
                          : Colors.red,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Gold: ${widget.result.loot.gold.toStringAsFixed(0)}',
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView(
                children: [
                  const Text(
                    'Cargo',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  if (widget.result.loot.inventory.isEmpty)
                    const Text('None'),

                  ...widget.result.loot.inventory.map(
                    (item) => _checkboxTile(
                      item: item,
                      label:
                          '${item.good.name} x${item.quantity}',
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Weapons',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  if (widget.result.loot.weapons.isEmpty)
                    const Text('None'),

                  ...widget.result.loot.weapons.map(
                    (weapon) => _checkboxTile(
                      item: weapon,
                      label: weapon.name,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Armours',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  if (widget.result.loot.armours.isEmpty)
                    const Text('None'),

                  ...widget.result.loot.armours.map(
                    (armour) => _checkboxTile(
                      item: armour,
                      label: armour.name,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Helmets',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  if (widget.result.loot.helmets.isEmpty)
                    const Text('None'),

                  ...widget.result.loot.helmets.map(
                    (helmet) => _checkboxTile(
                      item: helmet,
                      label: helmet.name,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Animals',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  if (widget.result.loot.animals.isEmpty)
                    const Text('None'),

                  ...widget.result.loot.animals.map(
                    (animal) => _checkboxTile(
                      item: animal,
                      label: animal.type.name,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Vehicles',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  if (widget.result.loot.vehicles.isEmpty)
                    const Text('None'),

                  ...widget.result.loot.vehicles.map(
                    (vehicle) => _checkboxTile(
                      item: vehicle,
                      label: vehicle.type.name,
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Your Losses',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  if (widget.result.playerDeaths.isEmpty)
                    const Text('None'),

                  ...widget.result.playerDeaths.map(
                    (name) => Text('• $name'),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Enemy Losses',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  if (widget.result.enemyDeaths.isEmpty)
                    const Text('None'),

                  ...widget.result.enemyDeaths.map(
                    (name) => Text('• $name'),
                  ),
                ],
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _takeAll,
                    child: const Text(
                      'Take All',
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: ElevatedButton(
                    onPressed: _takeSelected,
                    child: const Text(
                      'Take Selected',
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: ElevatedButton(
                    onPressed: _continue,
                    child: const Text(
                      'Continue',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}