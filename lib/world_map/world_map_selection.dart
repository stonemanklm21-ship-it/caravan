import '../core/models/city.dart';
import '../core/models/npc_caravan.dart';

class WorldMapSelection {
  final City? city;

  final NpcCaravan? npcCaravan;

  final double? worldX;

  final double? worldY;

  const WorldMapSelection({
    this.city,
    this.npcCaravan,
    this.worldX,
    this.worldY,
  });

  const WorldMapSelection.city(
    City city,
  ) : city = city,
      npcCaravan = null,
      worldX = null,
      worldY = null;

  const WorldMapSelection.npcCaravan(
    NpcCaravan npcCaravan,
  ) : city = null,
      npcCaravan = npcCaravan,
      worldX = null,
      worldY = null;

  const WorldMapSelection.location({
    required double worldX,
    required double worldY,
  }) : city = null,
       npcCaravan = null,
       worldX = worldX,
       worldY = worldY;

  const WorldMapSelection.none()
      : city = null,
        npcCaravan = null,
        worldX = null,
        worldY = null;

  bool get isCity =>
      city != null;

  bool get isNpcCaravan =>
      npcCaravan != null;

  bool get isLocation =>
      worldX != null &&
      worldY != null;

  bool get hasSelection =>
      isCity ||
      isNpcCaravan ||
      isLocation;
}