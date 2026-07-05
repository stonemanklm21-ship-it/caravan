import '../core/models/city.dart';
import '../core/models/npc_caravan.dart';

class WorldMapEntitySelectionService {
  static City? nearestCity({
    required double worldX,
    required double worldY,
    required List<City> cities,
    double selectionRadius = 50,
  }) {
    City? nearestCity;

    double nearestDistanceSquared =
        selectionRadius *
            selectionRadius;

    for (final city in cities) {
      final dx =
          city.x - worldX;

      final dy =
          city.y - worldY;

      final distanceSquared =
          (dx * dx) +
          (dy * dy);

      if (distanceSquared <
          nearestDistanceSquared) {
        nearestDistanceSquared =
            distanceSquared;

        nearestCity = city;
      }
    }

    return nearestCity;
  }

  static NpcCaravan? nearestNpcCaravan({
    required double worldX,
    required double worldY,
    required List<NpcCaravan>
        npcCaravans,
    required double Function(
      NpcCaravan npc,
    ) getX,
    required double Function(
      NpcCaravan npc,
    ) getY,
    double selectionRadius = 50,
  }) {
    NpcCaravan? nearestNpc;

    double nearestDistanceSquared =
        selectionRadius *
            selectionRadius;


for (final npc in npcCaravans) {
  if (npc.activeJourney == null) {
    continue;
  }
      final dx =
          getX(npc) - worldX;

      final dy =
          getY(npc) - worldY;

      final distanceSquared =
          (dx * dx) +
          (dy * dy);

      if (distanceSquared <
          nearestDistanceSquared) {
        nearestDistanceSquared =
            distanceSquared;

        nearestNpc = npc;
      }
    }

    return nearestNpc;
  }
}