import '../models/player_state.dart';
import '../models/world.dart';
import '../models/character.dart';
import '../models/animal.dart';
import '../models/vehicle.dart';

class DeathService {
  static bool playerDead(
    PlayerState playerState,
  ) {
    return playerState.caravan.leader.hp <= 0;
  }

  static void processWorld({
    required World world,
  }) {
    for (final npc in world.npcCaravans.toList()) {
      _processCaravanDeaths(
        companions: npc.caravan.companions,
        animals: npc.caravan.animals,
        vehicles: npc.caravan.vehicles,
      );

      if (npc.caravan.leader.hp <= 0) {
        world.npcCaravans.remove(npc);
      }
    }
  }

  static void processPlayer({
    required PlayerState playerState,
  }) {
    _processCaravanDeaths(
      companions:
          playerState.caravan.companions,
      animals:
          playerState.caravan.animals,
      vehicles:
          playerState.caravan.vehicles,
    );
  }

  static void _processCaravanDeaths({
    required List<Character> companions,
    required List<Animal> animals,
    required List<Vehicle> vehicles,
  }) {
    companions.removeWhere(
      (companion) =>
          companion.hp <= 0,
    );

    final deadAnimals = animals
        .where(
          (animal) =>
              animal.hp <= 0,
        )
        .toList();

    for (final animal in deadAnimals) {
      for (final vehicle in vehicles) {
        if (vehicle.draftAnimal ==
            animal) {
          vehicle.draftAnimal = null;
        }
      }

      animals.remove(animal);
    }
  }
}