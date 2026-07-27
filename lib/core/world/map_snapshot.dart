import 'dart:ui';

import '../models/npc_caravan.dart';

class MapSnapshot {
  final double playerX;

  final double playerY;

  final bool playerTravelling;

  final bool npcTravelling;

  final Map<NpcCaravan, Offset>
      npcPositions;

  final List<NpcCaravan>
      visibleNpcs;
      

  const MapSnapshot({
    required this.playerX,
    required this.playerY,
    required this.npcPositions,
    required this.visibleNpcs,
    required this.playerTravelling,
    required this.npcTravelling,
  });
}