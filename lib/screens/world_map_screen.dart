import 'package:flutter/material.dart';

import '../core/npc/npc_travel_service.dart';
import '../core/travel/journey_service.dart';
import '../core/world/time_controller.dart';
import '../core/world/location_service.dart';
import '../data/cities_data.dart';
import '../data/game_data.dart';
import '../world_map/world_map_background_layer.dart';
import '../world_map/world_map_camera.dart';
import '../world_map/world_map_city_layer.dart';
import '../world_map/world_map_control_bar.dart';
import '../world_map/world_map_gesture_layer.dart';
import '../world_map/world_map_npc_layer.dart';
import '../world_map/world_map_player_layer.dart';
import '../world_map/world_map_selection.dart';
import '../world_map/world_map_selection_controller.dart';
import '../world_map/world_map_selection_strip.dart';
import '../world_map/world_map_status_bar.dart';
import '../world_map/world_map_travel_service.dart';
import '../world_map/world_map_navigation.dart';

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

  bool _followPlayer = false;
  bool _playerWasInCity = false;
  bool _returningToCity = false;
  double? _lastRenderedX;
  double? _lastRenderedY;


  @override
  void initState() {
    super.initState();

_playerWasInCity =
    game.player.currentCity != null;


    camera = WorldMapCamera(
      x: JourneyService.currentX(
        game.player,
      ),
      y: JourneyService.currentY(
        game.player,
      ),
      zoom: 1.5,
    );
WidgetsBinding.instance
    .addPostFrameCallback((_) {
  if (!mounted) {
    return;
  }

  camera.clampToWorld(
    viewportSize:
        MediaQuery.sizeOf(context),
  );

  setState(() {});
});
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

  final renderedX =
      JourneyService.currentXSmooth(
    game.player,
    _timeController.tickFraction,
  );

  final renderedY =
            JourneyService.currentYSmooth(game.player,
    _timeController.tickFraction,
  );

  if (game.player.activeJourney != null &&
      _lastRenderedX != null &&
      _lastRenderedY != null) {
    for (final city in game.world.cities) {
      if (city ==
          game.player.activeJourney!.originCity) {
        continue;
      }

      if (LocationService.segmentIntersectsCity(
        startX: _lastRenderedX!,
        startY: _lastRenderedY!,
        endX: renderedX,
        endY: renderedY,
        city: city,
      )) {
game.player.currentCity = city;
game.player.worldX = city.x;
game.player.worldY = city.y;

JourneyService.clearJourney(
  game.player,
);

        break;
      }
    }
  }

  _lastRenderedX = renderedX;
  _lastRenderedY = renderedY;

  final currentlyInCity =
      game.player.currentCity != null;


if (!_playerWasInCity &&
    currentlyInCity &&
    !_returningToCity) {
  _returningToCity = true;

  Future.microtask(() {
    if (mounted) {

      print('POPPING MAP');
      
      Navigator.of(context).pop();
    }
  });

  return;
}

  _playerWasInCity =
      currentlyInCity;

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

      if (_followPlayer &&
          playerTravelling) {
        final viewportSize =
            MediaQuery.sizeOf(
          context,
        );

        camera.x =
            JourneyService.currentXSmooth(
          game.player,
          _timeController.tickFraction,
        );

        camera.y =
            JourneyService.currentYSmooth(
          game.player,
          _timeController.tickFraction,
        );

        camera.clampToWorld(
          viewportSize: viewportSize,
        );
      }

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

    if (mounted) {
      _centreOnPlayer();
    }
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

    if (mounted) {
      _centreOnPlayer();
    }
  }

  void _centreOnPlayer() {
    final viewportSize =
        MediaQuery.sizeOf(context);

    setState(() {
      _followPlayer = true;

      camera.zoom = 1.5;

      camera.x =
          JourneyService.currentXSmooth(
        game.player,
        _timeController.tickFraction,
      );

      camera.y =
          JourneyService.currentYSmooth(
        game.player,
        _timeController.tickFraction,
      );

      camera.clampToWorld(
        viewportSize: viewportSize,
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
              onManualMove: () {
                if (_followPlayer) {
                  setState(() {
                    _followPlayer =
                        false;
                  });
                }
              },
              onCameraChanged: () {
                setState(() {});
              },
              child: Container(
                color: Colors.white,
                child: Stack(
                  children: [
                    WorldMapBackgroundLayer(
                      camera: camera,
                      viewportSize:
                          viewportSize,
                    ),

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
      JourneyService.currentXSmooth(
    game.player,
    tickFraction,
  ),
  playerY:
      JourneyService.currentYSmooth(
    game.player,
    tickFraction,
  ),
  headingDegrees:
      game.player.activeJourney ==
              null
          ? 0
          : WorldMapNavigation
              .headingDegrees(
              fromX:
                  JourneyService
                      .currentXSmooth(
                game.player,
                tickFraction,
              ),
              fromY:
                  JourneyService
                      .currentYSmooth(
                game.player,
                tickFraction,
              ),
              toX: game
                  .player
                  .activeJourney!
                  .destinationX,
              toY: game
                  .player
                  .activeJourney!
                  .destinationY,
            ),
  camera: camera,
  viewportSize:
      viewportSize,
),

                    if (selection.isCity)
                      WorldMapSelectionStrip(
                        title:
                            selection
                                .city!
                                .name,
                        actionText:
                            'Travel',
                        onAction:
                            _travelToSelectedCity,
                      ),

                    if (selection
                        .isNpcCaravan)
                      WorldMapSelectionStrip(
                        title:
                            'Merchant Caravan',
                        actionText:
                            'Follow',
                        onAction: () {
                          // TODO
                        },
                      ),

                    if (selection
                            .isLocation &&
                        game.player
                                .currentCity !=
                            null)
                      WorldMapSelectionStrip(
                        title:
                            '${selection.worldX!.round()}, ${selection.worldY!.round()}',
                        actionText:
                            'Travel',
                        onAction:
                            _travelToSelectedLocation,
                      ),

                    WorldMapStatusBar(
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

                    WorldMapControlBar(
                      timeController:
                          _timeController,
                      playerState:
                          game.player,
                      world:
                          game.world,
                      onChanged: () {
                        setState(() {});
                      },
                      onCentrePlayer:
                          _centreOnPlayer,
                      onSettings: () {Navigator.of(context).pop();
                        // TODO
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}