import 'package:flutter/material.dart';

import '../core/models/player_state.dart';
import '../core/models/world.dart';
import '../core/world/time_controller.dart';
import '../core/world/time_speed.dart';

class WorldMapTimeControls
    extends StatelessWidget {
  final TimeController timeController;

  final PlayerState playerState;

  final World world;

  final VoidCallback onChanged;

  const WorldMapTimeControls({
    super.key,
    required this.timeController,
    required this.playerState,
    required this.world,
    required this.onChanged,
  });

  void _setSpeed(
    TimeSpeed speed,
  ) {
    timeController.setSpeed(
      speed: speed,
      playerState: playerState,
      world: world,
      onTick: onChanged,
    );

    onChanged();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Positioned(
      left: 16,
      top: 16,
      child: Container(
        padding:
            const EdgeInsets.all(12),
        color: Colors.white,
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              'Speed: ${timeController.currentSpeed.name}',
            ),

            const SizedBox(
              height: 8,
            ),

            if (playerState.activeJourney !=
                null) ...[
              Text(
                'Destination: '
                '${playerState.activeJourney!.destinationCity?.name ?? 'Wilderness'}',
              ),
              Text(
                'Progress: '
                '${(playerState.activeJourney!.progress * 100).toStringAsFixed(0)}%',
              ),
              Text(
                'Remaining: '
                '${playerState.activeJourney!.remainingHours.toStringAsFixed(1)}h',
              ),
              const SizedBox(
                height: 8,
              ),
            ],

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      _setSpeed(
                    TimeSpeed.paused,
                  ),
                  child: const Text(
                    'Pause',
                  ),
                ),
                ElevatedButton(
                  onPressed: () =>
                      _setSpeed(
                    TimeSpeed.x1,
                  ),
                  child: const Text(
                    '1x',
                  ),
                ),
                ElevatedButton(
                  onPressed: () =>
                      _setSpeed(
                    TimeSpeed.x4,
                  ),
                  child: const Text(
                    '4x',
                  ),
                ),
                ElevatedButton(
                  onPressed: () =>
                      _setSpeed(
                    TimeSpeed.x24,
                  ),
                  child: const Text(
                    '24x',
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