import 'package:flutter/material.dart';

import '../core/models/player_state.dart';

class WorldMapCaravanStatusBar
    extends StatelessWidget {

  final PlayerState playerState;

  const WorldMapCaravanStatusBar({
    super.key,
    required this.playerState,
  });

  @override
  Widget build(BuildContext context) {
    final caravan =
        playerState.caravan;

    final overloaded =
        caravan.cargoWeightKg >
        caravan.cargoCapacityKg;

    return Positioned(
      left: 16,
      right: 16,
      top: 104,
      child: Container(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color:
              const Color(0xFF1A1A1A),
          borderRadius:
              BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white12,
          ),
        ),
        child: Row(
          children: [
            Text(
              'Speed ${caravan.speed.toStringAsFixed(1)}',
              style: TextStyle(
                color:
                    caravan.speed == 0
                        ? Colors.red
                        : Colors.white,
              ),
            ),

            const SizedBox(width: 24),

            Text(
              'Cargo '
              '${caravan.cargoWeightKg.toStringAsFixed(0)}'
              '/'
              '${caravan.cargoCapacityKg.toStringAsFixed(0)}kg',
              style: TextStyle(
                color: overloaded
                    ? Colors.red
                    : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}