import 'package:flutter/material.dart';

import '../core/models/player_state.dart';
import '../core/models/world.dart';
import '../core/world/time_controller.dart';
import '../core/world/time_speed.dart';

class WorldMapControlBar
    extends StatelessWidget {
  final TimeController timeController;
  final PlayerState playerState;
  final World world;
  final VoidCallback onChanged;
  final VoidCallback onCentrePlayer;
  final VoidCallback onSettings;

  const WorldMapControlBar({
    super.key,
    required this.timeController,
    required this.playerState,
    required this.world,
    required this.onChanged,
    required this.onCentrePlayer,
    required this.onSettings,
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
    final currentSpeed =
        timeController.currentSpeed;

    Widget speedButton(
      String label,
      TimeSpeed speed,
    ) {
      final selected =
          currentSpeed == speed;

      return TextButton(
        onPressed: () =>
            _setSpeed(speed),
        style: TextButton.styleFrom(
          foregroundColor: selected
              ? Colors.white
              : Colors.white70,
          backgroundColor:
              selected
                  ? Colors.white12
                  : Colors.transparent,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              10,
            ),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontWeight:
                FontWeight.w600,
          ),
        ),
      );
    }

    return Positioned(
      left: 16,
      right: 16,
      bottom: 16,
      child: Container(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
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
            IconButton(
              onPressed: onSettings,
              color: Colors.white70,
              icon: const Icon(
                Icons.settings,
              ),
            ),

            const Spacer(),

            IconButton(
              onPressed:
                  onCentrePlayer,
              color: Colors.white70,
              icon: const Icon(
                Icons.my_location,
              ),
            ),

            const SizedBox(
              width: 8,
            ),

            IconButton(
              onPressed: () =>
                  _setSpeed(
                TimeSpeed.paused,
              ),
              color:
                  currentSpeed ==
                          TimeSpeed
                              .paused
                      ? Colors.white
                      : Colors.white70,
              icon: const Icon(
                Icons.pause,
              ),
            ),

            speedButton(
              '1×',
              TimeSpeed.x1,
            ),

            const SizedBox(
              width: 4,
            ),

            speedButton(
              '2×',
              TimeSpeed.x4,
            ),
          ],
        ),
      ),
    );
  }
}