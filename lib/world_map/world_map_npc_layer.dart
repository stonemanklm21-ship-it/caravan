import 'dart:ui';

import 'package:flutter/material.dart';

import '../core/models/npc_caravan.dart';
import 'world_map_camera.dart';

class WorldMapNpcLayer extends StatelessWidget {
  final List<NpcCaravan> npcCaravans;

  final NpcCaravan? selectedNpcCaravan;

  final WorldMapCamera camera;

  final Size viewportSize;

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
            (npc) =>
                npc.activeJourney != null,
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

              return Positioned(
                left: screenPosition.dx,
                top: screenPosition.dy,
                child: Stack(
                  alignment:
                      Alignment.center,
                  children: [
                    if (npc ==
                        selectedNpcCaravan)
                      Container(
                        width: 32,
                        height: 32,
                        decoration:
                            BoxDecoration(
                          shape:
                              BoxShape.circle,
                          border:
                              Border.all(
                            color:
                                Colors.blue,
                            width: 2,
                          ),
                        ),
                      ),
                    Icon(
                      Icons.local_shipping,
                      color: npc ==
                              selectedNpcCaravan
                          ? Colors.blue
                          : Colors.green,
                    ),
                  ],
                ),
              );
            },
          )
          .toList(),
    );
  }
}