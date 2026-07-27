import 'package:flutter/material.dart';
import '../core/travel/journey_service.dart';
import '../core/world/time_controller.dart';
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
import '../screens/npc_trade_screen.dart';
import '../core/models/caravan_faction.dart';
import '../core/combat/combat_encounter.dart';
import '../screens/combat_screen.dart';
import '../core/world/map_runtime_service.dart';
import '../core/world/map_interaction_service.dart';
import '../core/world/map_encounter_interaction_service.dart';
import '../core/world/map_combat_interaction_service.dart';
import '../core/world/map_snapshot_service.dart';
import '../core/world/map_snapshot.dart';


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
bool _encounterActive = false;

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

if (game.player.encounteredNpc != null 
&&
    !_encounterActive
) {


  _encounterActive = true;
    _timeController.stop();

    final npc =
        game.player.encounteredNpc!;

if (npc.faction ==
    CaravanFaction.bandit) {
  Future.microtask(() {
    if (!mounted) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Bandit Encounter',
          ),
          content: const Text(
            'A bandit caravan blocks your path.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                MapEncounterInteractionService
    .dismissEncounter(
  player: game.player,
);

                _encounterActive = false;

                Navigator.pop(context);
              },
              child: const Text(
                'Continue',
              ),
            ),
            TextButton(
              onPressed: () {
                MapEncounterInteractionService.prepareCombat(player: game.player,);

                _encounterActive = false;

                Navigator.pop(context);

Navigator.push<bool>(
  this.context,
  MaterialPageRoute(
    builder: (_) => CombatScreen(
      encounter: CombatEncounter(
        attackers: npc.caravan,
        defenders: game.player.caravan,
        attackerFaction: npc.faction,
        defenderFaction:
            CaravanFaction.merchant,
      ),
    ),
  ),
).then(
  (playerWon) {
    if (playerWon == true) {
setState(() {
  MapCombatInteractionService
      .removeDefeatedNpc(
    world: game.world,
    npc: npc,
  );
});
    }
  },
);
              },
              child: const Text(
                'Fight',
              ),
            ),
          ],
        );
      },
    );
  });

  return;
}

    Future.microtask(() {
      if (!mounted) {
        return;
      }

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              'Caravan Encounter',
            ),
            content: const Text(
              'You have encountered a merchant caravan.',
            ),  
            actions: [
              TextButton(
onPressed: () {
MapEncounterInteractionService
    .ignoreEncounter(
  player: game.player,
  npc: npc,
);

  _encounterActive = false;

  Navigator.pop(context);
},
                child: const Text(
                  'Ignore',
                ),
              ),
              TextButton(
onPressed: () {
MapEncounterInteractionService
    .dismissEncounter(
  player: game.player,
);

  _encounterActive = false;

  Navigator.pop(context);

  Navigator.push(
    this.context,
    MaterialPageRoute(
      builder: (_) => NpcTradeScreen(
        npc: npc,
      ),
    ),
  );
},
                child: const Text(
                  'Trade',
                ),
              ),
            ],
          );
        },
      );
    });

    return;
  }

final snapshot =  _currentSnapshot();

final renderedX = snapshot.playerX;

final renderedY = snapshot.playerY;

final mapEvent =
    MapRuntimeService.update(
  player: game.player,
  world: game.world,
  tickFraction:
      _timeController.tickFraction,
  worldTimeHours:
      game.player.worldTimeHours,
  renderedX: renderedX,
  renderedY: renderedY,
  lastRenderedX:
      _lastRenderedX,
  lastRenderedY:
      _lastRenderedY,
);

if (mapEvent != null) {
  // handled later
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
      
      Navigator.of(context).pop();
    }
  });

  return;
}

  _playerWasInCity =
      currentlyInCity;

if (_followPlayer &&
    snapshot.playerTravelling)
{
        final viewportSize =
            MediaQuery.sizeOf(
          context,
        );

camera.x = renderedX;
camera.y = renderedY;

        camera.clampToWorld(
          viewportSize: viewportSize,
        );
      }

if (snapshot.playerTravelling ||
    snapshot.npcTravelling) {
        setState(() {});
      }
    });
  }

MapSnapshot _currentSnapshot() {
  return MapSnapshotService.build(
    player: game.player,
    world: game.world,
    tickFraction:
        _timeController.tickFraction,
  );
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

final snapshot =
    _currentSnapshot();

camera.x = snapshot.playerX;
camera.y = snapshot.playerY;

      camera.clampToWorld(
        viewportSize: viewportSize,
      );
    });
  }

Future<void> _handleTap({
  required TapUpDetails details,
  required Size viewportSize,
  required MapSnapshot snapshot,
}) async {

    final worldPosition =
        camera.screenToWorld(
      screenX:
          details.localPosition.dx,
      screenY:
          details.localPosition.dy,
      viewportSize: viewportSize,
    );

    final newSelection = WorldMapSelectionController.selectionFromWorldPosition(
        
      worldX:             worldPosition.dx,
      worldY:             worldPosition.dy,
      cities:             cities,
      npcCaravans:        game.world.npcCaravans,
      npcPositions:       snapshot.npcPositions,
    );
if (!newSelection.isNpcCaravan) {
MapInteractionService
    .clearFollowTarget(
  player: game.player,
);
}
if (newSelection.isCity &&
    game.player.currentCity == null) {
  await WorldMapTravelService
      .travelToCity(
    context: context,
    playerState: game.player,
    city: newSelection.city!,
    world: game.world,
    timeController: _timeController,
    onChanged: () {
      setState(() {});
    },
  );

  return;
}

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

final snapshot =
    MapSnapshotService.build(
  player: game.player,
  world: game.world,
  tickFraction:
      tickFraction,
);

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
  snapshot: snapshot,
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
                      selectedCity:  selection.city,
                      camera: camera,
                      viewportSize:                          viewportSize,                    ),

WorldMapNpcLayer(
  npcCaravans:           snapshot.visibleNpcs,
  selectedNpcCaravan:    selection.npcCaravan,
  camera:                camera,
  viewportSize:          viewportSize,
  npcPositions:          snapshot.npcPositions,),

WorldMapPlayerLayer(
  playerX: snapshot.playerX,
  playerY: snapshot.playerY,
  headingDegrees: game.player.activeJourney ==  null
          ? 0
          : WorldMapNavigation
              .headingDegrees(
                  fromX: snapshot.playerX,
                  fromY: snapshot.playerY,
                  toX: game.player.activeJourney!.destinationX,
                  toY: game.player.activeJourney!.destinationY,
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
MapInteractionService
    .followNpc(
  player: game.player,
  npc: selection.npcCaravan!,
);
}
,
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