import '../city/animal_health_service.dart';
import '../city/person_health_service.dart';
import '../models/npc_caravan.dart';

class NpcCaravanHealthService {
  static void visitDoctor({
    required NpcCaravan npc,
  }) {
    final city = npc.currentCity;

    if (city == null || !city.hasDoctor) {
      return;
    }

    final characters = [
      npc.caravan.leader,
      ...npc.caravan.companions,
    ];

    for (final character in characters) {
      final cost =
          CharacterHealthService.healCost(
        character,
      );

      if (!CharacterHealthService.canHeal(
            character,
          ) ||
          npc.caravan.gold < cost) {
        continue;
      }

      npc.caravan.gold -= cost;

      CharacterHealthService.heal(
        character,
      );
    }
  }

  static void visitVet({
    required NpcCaravan npc,
  }) {
    final city = npc.currentCity;

    if (city == null || !city.hasVet) {
      return;
    }

    for (final animal in npc.caravan.animals) {
      final cost =
          AnimalHealthService.healCost(
        animal,
      );

      if (!AnimalHealthService.canHeal(
            animal,
          ) ||
          npc.caravan.gold < cost) {
        continue;
      }

      npc.caravan.gold -= cost;

      AnimalHealthService.heal(
        animal,
      );
    }
  }
}