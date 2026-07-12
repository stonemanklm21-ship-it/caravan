import 'package:flutter/material.dart';

import '../core/models/player_state.dart';
import '../core/models/world.dart';
import '../core/travel/journey_service.dart';
import '../core/world/time_controller.dart';
import 'world_map_coordinates.dart';
import 'world_map_heading.dart';
import 'world_map_navigation.dart';

class WorldMapStatusBar
    extends StatelessWidget {
  final TimeController timeController;
  final PlayerState playerState;
  final World world;
  final VoidCallback onChanged;

  const WorldMapStatusBar({
    super.key,
    required this.timeController,
    required this.playerState,
    required this.world,
    required this.onChanged,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final playerX =
        JourneyService.currentXSmooth(
      playerState,
      timeController.tickFraction,
    );

    final playerY =
        JourneyService.currentYSmooth(
      playerState,
      timeController.tickFraction,
    );

    double foodCalories = 0;

    for (final item
        in playerState.caravan.inventory) {
      foodCalories +=
          item.quantity *
          item.good.caloriesPerUnit;
    }

    final water =
        playerState.caravan.quantityOf(
      'water',
    );

    final forage =
        playerState.caravan.quantityOf(
      'forage',
    );

    double? heading;

    final journey =
        playerState.activeJourney;

    if (journey != null) {
      heading =
          WorldMapNavigation
              .headingDegrees(
        fromX: playerX,
        fromY: playerY,
        toX: journey.destinationX,
        toY: journey.destinationY,
      );
    }

    return Positioned(
      left: 16,
      right: 16,
      top: 48,
      child: Container(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: const Color(
            0xFF1A1A1A,
          ),
          borderRadius:
              BorderRadius.circular(
            20,
          ),
          border: Border.all(
            color: Colors.white12,
            width: 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 12,
              offset: Offset(
                0,
                4,
              ),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(
              '${WorldMapCoordinates.eastWest(playerX)} ${WorldMapCoordinates.northSouth(playerY)}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight:
                    FontWeight.w600,
              ),
            ),

            if (heading != null) ...[
              const SizedBox(
                width: 16,
              ),
              WorldMapHeading(
                headingDegrees:
                    heading,
              ),
            ],

            const Spacer(),

            Text(
              '🍖 ${foodCalories.round()}',
              style: const TextStyle(
                color: Color(
                  0xFFFFD166,
                ),
                fontWeight:
                    FontWeight.w600,
              ),
            ),

            const SizedBox(
              width: 16,
            ),

            Text(
              '💧 ${water.toStringAsFixed(1)}',
              style: const TextStyle(
                color: Color(
                  0xFF6EC6FF,
                ),
                fontWeight:
                    FontWeight.w600,
              ),
            ),

            const SizedBox(
              width: 16,
            ),

            Text(
              '🌿 ${forage.toStringAsFixed(1)}',
              style: const TextStyle(
                color: Color(
                  0xFF7DFF7D,
                ),
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}