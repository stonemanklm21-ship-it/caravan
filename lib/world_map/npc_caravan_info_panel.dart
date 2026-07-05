import 'package:flutter/material.dart';

import '../core/models/npc_caravan.dart';

class NpcCaravanInfoPanel
    extends StatelessWidget {
  final NpcCaravan npcCaravan;

  const NpcCaravanInfoPanel({
    super.key,
    required this.npcCaravan,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final caravan =
        npcCaravan.caravan;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding:
            const EdgeInsets.all(
          16,
        ),
        color: Colors.white,
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              'Caravan',
              style: Theme.of(
                context,
              ).textTheme.titleLarge,
            ),

            Text(
              'Companions: ${caravan.companions.length}',
            ),

            Text(
              'Animals: ${caravan.animals.length}',
            ),

            Text(
              'Vehicles: ${caravan.vehicles.length}',
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              'Speed: ${caravan.speed.toStringAsFixed(2)}',
            ),

            Text(
              'Capacity: ${caravan.cargoCapacityKg.toStringAsFixed(0)} kg',
            ),

            const SizedBox(
              height: 8,
            ),

            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    'Inspect',
                  ),
                ),

                ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    'Follow',
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