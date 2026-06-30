import '../models/game_state.dart';
import '../models/world.dart';
import 'time_service.dart';

class SimulationService {
  static const double tickHours = 1;

  static void tick({
    required GameState gameState,
    required World world,
  }) {
    TimeService.advanceTime(
      gameState: gameState,
      world: world,
      hours: tickHours,
    );
  }
}
