import '../core/models/city.dart';
import '../core/models/npc_caravan.dart';
import '../world_map/world_map_entity_selection_service.dart';
import '../world_map/world_map_selection.dart';

class WorldMapSelectionController {
  static WorldMapSelection
      selectionFromWorldPosition({
    required double worldX,
    required double worldY,
    required List<City> cities,
    required List<NpcCaravan>
        npcCaravans,
    required double Function(
      NpcCaravan npc,
    ) getNpcX,
    required double Function(
      NpcCaravan npc,
    ) getNpcY,
  }) {
    final npc =
        WorldMapEntitySelectionService
            .nearestNpcCaravan(
      worldX: worldX,
      worldY: worldY,
      npcCaravans: npcCaravans,
      getX: getNpcX,
      getY: getNpcY,
    );

    if (npc != null) {
      return WorldMapSelection
          .npcCaravan(
        npc,
      );
    }

    final city =
        WorldMapEntitySelectionService
            .nearestCity(
      worldX: worldX,
      worldY: worldY,
      cities: cities,
    );

    if (city != null) {
      return WorldMapSelection.city(
        city,
      );
    }

return WorldMapSelection.location(
  worldX: worldX,
  worldY: worldY,
);
  }
}
