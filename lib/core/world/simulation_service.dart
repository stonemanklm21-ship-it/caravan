import '../models/player_state.dart';
import '../models/world.dart';
import 'time_service.dart';

class SimulationService {
  static const double tickHours = 1;

  static void tick({
    required PlayerState playerState,
    required World world,
  }) {
    TimeService.advanceTime(
      playerState: playerState,
      world: world,
      hours: tickHours,
    );
  }
}