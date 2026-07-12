import 'package:flutter/material.dart';
import 'world_map_coordinates.dart';

class WorldMapLocationPanel
    extends StatelessWidget {
  final double worldX;

  final double worldY;

  final VoidCallback onTravel;

  const WorldMapLocationPanel({
    super.key,
    required this.worldX,
    required this.worldY,
    required this.onTravel,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding:
            const EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              'Wilderness',
              style: Theme.of(
                context,
              ).textTheme.titleLarge,
            ),

            const SizedBox(
              height: 8,
            ),

Text(
  WorldMapCoordinates.eastWest(
    worldX,
  ),
),
Text(
  WorldMapCoordinates.northSouth(
    worldY,
  ),
),
            const SizedBox(
              height: 8,
            ),

            ElevatedButton(
              onPressed: onTravel,
              child: const Text(
                'Travel Here',
              ),
            ),
          ],
        ),
      ),
    );
  }
}