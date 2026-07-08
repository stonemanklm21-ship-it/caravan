import 'package:flutter/material.dart';

import '../core/npc/npc_travel_service.dart';
import '../core/travel/journey_service.dart';
import '../core/world/time_controller.dart';
import '../data/cities_data.dart';
import '../data/game_data.dart';
import '../world_map/city_info_panel.dart';
import '../world_map/npc_caravan_info_panel.dart';
import '../world_map/world_map_camera.dart';
import '../world_map/world_map_city_layer.dart';
import '../world_map/world_map_gesture_layer.dart';
import '../world_map/world_map_hud.dart';
import '../world_map/world_map_location_panel.dart';
import '../world_map/world_map_npc_layer.dart';
import '../world_map/world_map_player_layer.dart';
import '../world_map/world_map_selection.dart';
import '../world_map/world_map_selection_controller.dart';
import '../world_map/world_map_travel_service.dart';

class WorldMapScreen extends StatefulWidget {
  const WorldMapScreen({
    super.key,
  });

  @override
  State<WorldMapScreen> createState() =>
      _WorldMapScreenState();
}

class _WorldMapScreenState
    extends State<WorldMapScreen>
    with SingleTickerProviderStateMixin {
  late WorldMapCamera camera;

  late final AnimationController
      _renderController;

  final TimeController _timeController =
      TimeController();

  WorldMapSelection selection =
      const WorldMapSelection.none();

  @override
  void initState() {
    super.initState();

    camera = WorldMapCamera(
      x: JourneyService.currentX(
        game.player,
      ),
      y: JourneyService.currentY(
        game.player,
      ),
      zoom: 1.5,
    );

    _renderController =
        AnimationController.unbounded(
      vsync: this,
    )..repeat(
            min: 0,
            max: 1,
            period: const Duration(
              milliseconds: 16,
            ),
          );

    _renderController.addListener(() {
      if (!mounted) {
        return;
      }

      final playerTravelling =
          game.player.activeJourney !=
              null;

      final npcTravelling = game
          .world.npcCaravans
          .any(
            (npc) =>
                npc.activeJourney !=
                null,
          );

      if (playerTravelling ||
          npcTravelling) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _renderController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void>
      _travelToSelectedCity() async {
    if (selection.city == null) {
      return;
    }

    await WorldMapTravelService
        .travelToCity(
      context: context,
      playerState: game.player,
      city: selection.city!,
      world: game.world,
      timeController:
          _timeController,
      onChanged: () {
        setState(() {});
      },
    );
  }

  Future<void>
      _travelToSelectedLocation() async {
    if (!selection.isLocation) {
      return;
    }

    await WorldMapTravelService
        .travelToCoordinates(
      context: context,
      playerState: game.player,
      destinationX:
          selection.worldX!,
      destinationY:
          selection.worldY!,
      world: game.world,
      timeController:
          _timeController,
      onChanged: () {
        setState(() {});
      },
    );
  }

  void _centreOnPlayer() {
    setState(() {
      camera.x =
          JourneyService
              .currentXSmooth(
        game.player,
        _timeController
            .tickFraction,
      );

      camera.y =
          JourneyService
              .currentYSmooth(
        game.player,
        _timeController
            .tickFraction,
      );
    });
  }

  Future<void> _handleTap({
    required TapUpDetails details,
    required Size viewportSize,
  }) async {
    final worldPosition =
        camera.screenToWorld(
      screenX:
          details.localPosition.dx,
      screenY:
          details.localPosition.dy,
      viewportSize: viewportSize,
    );

    final newSelection =
        WorldMapSelectionController
            .selectionFromWorldPosition(
      worldX: worldPosition.dx,
      worldY: worldPosition.dy,
      cities: cities,
      npcCaravans:
          game.world.npcCaravans,
      getNpcX: (npc) =>
          NpcTravelService
              .currentXSmooth(
        npc,
        _timeController
            .tickFraction,
      ),
      getNpcY: (npc) =>
          NpcTravelService
              .currentYSmooth(
        npc,
        _timeController
            .tickFraction,
      ),
    );

    if (newSelection.isLocation &&
        game.player.currentCity ==
            null) {
      await WorldMapTravelService
          .travelToCoordinates(
        context: context,
        playerState: game.player,
        destinationX:
            newSelection.worldX!,
        destinationY:
            newSelection.worldY!,
        world: game.world,
        timeController:
            _timeController,
        onChanged: () {
          setState(() {});
        },
      );

      return;
    }

    setState(() {
      selection = newSelection;
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final tickFraction =
        _timeController.tickFraction;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'World Map',
        ),
      ),
      body: LayoutBuilder(
        builder: (
          context,
          constraints,
        ) {
          final viewportSize = Size(
            constraints.maxWidth,
            constraints.maxHeight,
          );

          return GestureDetector(
            behavior:
                HitTestBehavior.opaque,
            onTapUp: (details) async {
              await _handleTap(
                details: details,
                viewportSize:
                    viewportSize,
              );
            },
            child: WorldMapGestureLayer(
              camera: camera,
              onCameraChanged: () {
                setState(() {});
              },
              child: Container(
                color: Colors.white,
                child: Stack(
                  children: [
                    WorldMapCityLayer(
                      cities: cities,
                      selectedCity:
                          selection.city,
                      camera: camera,
                      viewportSize:
                          viewportSize,
                    ),

                    WorldMapNpcLayer(
                      npcCaravans: game
                          .world
                          .npcCaravans,
                      selectedNpcCaravan:
                          selection
                              .npcCaravan,
                      camera: camera,
                      viewportSize:
                          viewportSize,
                      getX: (npc) =>
                          NpcTravelService
                              .currentXSmooth(
                        npc,
                        tickFraction,
                      ),
                      getY: (npc) =>
                          NpcTravelService
                              .currentYSmooth(
                        npc,
                        tickFraction,
                      ),
                    ),

                    WorldMapPlayerLayer(
                      playerX:
                          JourneyService
                              .currentXSmooth(
                        game.player,
                        tickFraction,
                      ),
                      playerY:
                          JourneyService
                              .currentYSmooth(
                        game.player,
                        tickFraction,
                      ),
                      camera: camera,
                      viewportSize:
                          viewportSize,
                    ),

                    if (selection.isCity)
                      CityInfoPanel(
                        city:
                            selection.city!,
                        onTravel:
                            _travelToSelectedCity,
                      ),

                    if (selection
                        .isNpcCaravan)
                      NpcCaravanInfoPanel(
                        npcCaravan:
                            selection
                                .npcCaravan!,
                      ),

                    if (selection
                            .isLocation &&
                        game.player
                                .currentCity !=
                            null)
                      WorldMapLocationPanel(
                        worldX:
                            selection
                                .worldX!,
                        worldY:
                            selection
                                .worldY!,
                        onTravel:
                            _travelToSelectedLocation,
                      ),

                    WorldMapHud(
                      timeController:
                          _timeController,
                      playerState:
                          game.player,
                      world:
                          game.world,
                      onChanged: () {
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton:
          FloatingActionButton(
        onPressed:
            _centreOnPlayer,
        child: const Icon(
          Icons.my_location,
        ),
      ),
    );
  }
}