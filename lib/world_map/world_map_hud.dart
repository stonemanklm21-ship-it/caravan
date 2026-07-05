import 'package:flutter/material.dart';

import '../core/models/player_state.dart';
import '../core/models/world.dart';
import '../core/world/time_controller.dart';
import 'world_map_time_controls.dart';

class WorldMapHud extends StatelessWidget {
  final TimeController timeController;

  final PlayerState playerState;

  final World world;

  final VoidCallback onChanged;

  const WorldMapHud({
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
    return WorldMapTimeControls(
      timeController:
          timeController,
      playerState:
          playerState,
      world: world,
      onChanged: onChanged,
    );
  }
}