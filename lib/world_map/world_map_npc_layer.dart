import 'package:flutter/material.dart';

import '../core/models/npc_caravan.dart';
import '../core/models/caravan_faction.dart';
import '../core/world/visibility_service.dart';

import 'world_map_camera.dart';
import 'world_map_npc_marker.dart';

class WorldMapNpcLayer
    extends StatelessWidget {
  final List<NpcCaravan> npcCaravans;

  final NpcCaravan? selectedNpcCaravan;

  final WorldMapCamera camera;

  final Size viewportSize;

  final double playerX;

  final double playerY;

  final double Function(
    NpcCaravan npc,
  ) getX;

  final double Function(
    NpcCaravan npc,
  ) getY;

  const WorldMapNpcLayer({
    super.key,
    required this.npcCaravans,
    required this.selectedNpcCaravan,
    required this.camera,
    required this.viewportSize,
    required this.playerX,
    required this.playerY,
    required this.getX,
    required this.getY,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Stack(
      children: npcCaravans
          .where(
            (npc) {
              if (npc.activeJourney ==
                  null) {
                return false;
              }

              return VisibilityService
                  .canSee(
                observerX: playerX,
                observerY: playerY,
                targetX: getX(npc),
                targetY: getY(npc),
                range:
                    VisibilityService
                        .caravanVisionRange,
              );
            },
          )
          .map(
            (npc) {
              final screenPosition =
                  camera.worldToScreen(
                worldX: getX(npc),
                worldY: getY(npc),
                viewportSize:
                    viewportSize,
              );

              final markerSize =
                  (18 * camera.zoom)
                      .clamp(
                8.0,
                28.0,
              );

              return Positioned(
                left:
                    screenPosition.dx -
                    (markerSize + 8) / 2,
                top:
                    screenPosition.dy -
                    (markerSize + 8) / 2,
                child: SizedBox(
                  width:
                      markerSize + 8,
                  height:
                      markerSize + 8,
                  child: Stack(
                    alignment:
                        Alignment.center,
                    children: [
                      if (npc ==
                          selectedNpcCaravan)
                        Container(
                          width:
                              markerSize +
                              8,
                          height:
                              markerSize +
                              8,
                          decoration:
                              BoxDecoration(
                            shape:
                                BoxShape
                                    .circle,
                            border:
                                Border.all(
                              color:
                                  Colors.blue,
                              width: 2,
                            ),
                          ),
                        ),
                      WorldMapNpcMarker(
                        zoom:
                            camera.zoom,
                        color: npc ==
                                selectedNpcCaravan
                            ? Colors.blue
                            : npc.faction ==
                                    CaravanFaction
                                        .bandit
                                ? Colors.red
                                : Colors.orange,
                      ),
                    ],
                  ),
                ),
              );
            },
          )
          .toList(),
    );
  }
}