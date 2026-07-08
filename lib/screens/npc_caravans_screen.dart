import 'package:flutter/material.dart';

import '../core/world/time_controller.dart';
import '../core/world/time_speed.dart';
import '../data/game_data.dart';
import '../core/caravan/animal_service.dart';

class NpcCaravansScreen extends StatefulWidget {
  const NpcCaravansScreen({super.key});

  @override
  State<NpcCaravansScreen> createState() =>
      _NpcCaravansScreenState();
}

class _NpcCaravansScreenState
    extends State<NpcCaravansScreen> {
  final TimeController _timeController =
      TimeController();

  void _setSpeed(TimeSpeed speed) {
    _timeController.setSpeed(
      speed: speed,
      playerState: game.player,
      world: game.world,
      onTick: () {
        if (mounted) {
          setState(() {});
        }
      },
    );

    setState(() {});
  }

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final npcs = game.world.npcCaravans;

    return Scaffold(
      appBar: AppBar(
        title: Text('NPC Caravans (${npcs.length})'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Row(
              children: [
                Text(
                  'Speed: ${_timeController.currentSpeed.name}',
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () =>
                      _setSpeed(TimeSpeed.paused),
                  child: const Text('Pause'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () =>
                      _setSpeed(TimeSpeed.x1),
                  child: const Text('1x'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: npcs.length,
              itemBuilder: (context, index) {
                final npc = npcs[index];
                final caravan = npc.caravan;

                final foodCalories =
                    caravan.inventory.fold<double>(
                  0,
                  (total, item) =>
                      total +
                      item.quantity *
                          item.good.caloriesPerUnit,
                );

                final foodDays =
                    caravan.calorieRequirementPerDay > 0
                        ? foodCalories /
                            caravan
                                .calorieRequirementPerDay
                        : 0;

                final waterDays =
                    caravan.waterRequirementPerDay > 0
                        ? caravan.quantityOf('water') /
                            caravan
                                .waterRequirementPerDay
                        : 0;

                final forageDays =
                    caravan.forageRequirementPerDay > 0
                        ? caravan.quantityOf('forage') /
                            caravan
                                .forageRequirementPerDay
                        : 0;

                return Card(
                  margin:
                      const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          'NPC ${index + 1}',
                          style:
                              const TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'Status: ${npc.activeJourney == null ? 'Idle' : 'Travelling'}',
                        ),

Text('Last Decision: ${npc.lastDecision}'),
                        Text(
                          'Location: ${npc.currentCity?.name ?? 'En Route'}',
                        ),

                        const Divider(),

                        const Text(
                          'Trade State',
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        Text(
                          'Gold: ${caravan.gold.toStringAsFixed(0)}, Cargo: ${caravan.cargoWeightKg.toStringAsFixed(1)} / ${caravan.cargoCapacityKg.toStringAsFixed(1)} kg',
                        ),

                        const SizedBox(height: 6),

                        if (caravan.inventory.isEmpty)
                          const Text(
                            'Inventory: Empty',
                          ),

                        ...caravan.inventory.map(
                          (item) => Text(
                            '${item.good.name}: ${item.quantity.toStringAsFixed(1)}',
                          ),
                        ),

                        const Divider(),

                        const Text(
                          'Logistics',
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        Text(
                          'Food: ${foodDays.toStringAsFixed(1)} days, Water: ${waterDays.toStringAsFixed(1)} days, Forage: ${forageDays.toStringAsFixed(1)} days',
                        ),

                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}