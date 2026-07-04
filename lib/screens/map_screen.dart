import 'dart:math';

import 'package:flutter/material.dart';

import '../core/models/city.dart';
import '../core/npc/npc_travel_service.dart';
import '../core/travel/journey_route_painter.dart';
import '../core/travel/journey_service.dart';
import '../core/travel/travel_service.dart';
import '../core/world/time_controller.dart';
import '../core/world/time_speed.dart';
import '../data/cities_data.dart';
import '../data/game_data.dart';
import '../widgets/travel_confirmation_dialog.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
  });

  @override
  State<MapScreen> createState() =>
      _MapScreenState();
}

class _MapScreenState
    extends State<MapScreen> {
  static const double caravanIconRadius =
      20;

  static const double cityTapRadius =
      50;

  final TimeController _timeController =
      TimeController();

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _handleMapTap(
    TapDownDetails details,
  ) async {
    final tapX =
        details.localPosition.dx;

    final tapY =
        details.localPosition.dy;

    for (final city in cities) {
      final dx = city.x - tapX;
      final dy = city.y - tapY;

      final distance = sqrt(
        (dx * dx) + (dy * dy),
      );

      if (distance <= cityTapRadius) {
        await _travelTo(city);
        return;
      }
    }

    final confirmed =
        await showDialog<bool>(
      context: context,
      builder: (_) =>
          TravelConfirmationDialog(
        playerState: game.player,
        destinationX: tapX,
        destinationY: tapY,
      ),
    );

    if (confirmed != true) {
      return;
    }

    TravelService
        .startTravelToCoordinates(
      playerState: game.player,
      destinationX: tapX,
      destinationY: tapY,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'World Map',
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTapDown: _handleMapTap,
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size.infinite,
                    painter:
                        JourneyRoutePainter(
                      playerState:
                          game.player,
                    ),
                  ),

                  ...cities
                      .where(
                        (city) => game
                            .player
                            .discoveredCities
                            .contains(
                              city.id,
                            ),
                      )
                      .map(
                        (city) =>
                            Positioned(
                          left: city.x - 16,
                          top: city.y - 16,
                          child:
                              IgnorePointer(
                            child: Column(
                              mainAxisSize:
                                  MainAxisSize
                                      .min,
                              children: [
                                const Icon(
                                  Icons
                                      .location_city,
                                  size: 32,
                                ),
                                Text(
                                  city.name,
                                  textAlign:
                                      TextAlign
                                          .center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),

          ...game.world.npcCaravans.map(
            (npc) => Positioned(
              left:
                  NpcTravelService
                          .currentX(
                        npc,
                      ) -
                      12,
              top:
                  NpcTravelService
                          .currentY(
                        npc,
                      ) -
                      12,
              child:
                  const IgnorePointer(
                child: Icon(
                  Icons.local_shipping,
                  color: Colors.green,
                  size: 24,
                ),
              ),
            ),
          ),

          Positioned(
            left:
                JourneyService.currentX(
                      game.player,
                    ) -
                    caravanIconRadius,
            top:
                JourneyService.currentY(
                      game.player,
                    ) -
                    caravanIconRadius,
            child: const IgnorePointer(
              child: Icon(
                Icons.person_pin_circle,
                color: Colors.red,
                size: 40,
              ),
            ),
          ),

          Positioned(
            left: 16,
            bottom: 16,
            child: Container(
              padding:
                  const EdgeInsets.all(
                12,
              ),
              color: Colors.white,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    'Day ${game.player.day}',
                  ),
                  Text(
                    '${game.player.hour.toString().padLeft(2, '0')}:00',
                  ),
                  Text(
                    'Speed: ${_timeController.currentSpeed.name}',
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    'NPC Caravans: ${game.world.npcCaravans.length}',
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  if (game.player
                          .activeJourney !=
                      null) ...[
                    Text(
                      'Destination: '
                      '${game.player.activeJourney!.destinationCity?.name ?? 'Wilderness'}',
                    ),
                    Text(
                      'Progress: '
                      '${(game.player.activeJourney!.progress * 100).toStringAsFixed(0)}%',
                    ),
                    Text(
                      'Remaining: '
                      '${game.player.activeJourney!.remainingHours.toStringAsFixed(1)}h',
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],

                  Text(
                    'X: ${JourneyService.currentX(game.player).toStringAsFixed(1)}',
                  ),
                  Text(
                    'Y: ${JourneyService.currentY(game.player).toStringAsFixed(1)}',
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _timeController
                              .setSpeed(
                            speed:
                                TimeSpeed
                                    .paused,
                            playerState:
                                game.player,
                            world:
                                game.world,
                            onTick: () {
                              setState(
                                () {},
                              );
                            },
                          );

                          setState(() {});
                        },
                        child: const Text(
                          'Pause',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _timeController
                              .setSpeed(
                            speed:
                                TimeSpeed.x1,
                            playerState:
                                game.player,
                            world:
                                game.world,
                            onTick: () {
                              setState(
                                () {},
                              );
                            },
                          );

                          setState(() {});
                        },
                        child: const Text(
                          '1x',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _timeController
                              .setSpeed(
                            speed:
                                TimeSpeed.x4,
                            playerState:
                                game.player,
                            world:
                                game.world,
                            onTick: () {
                              setState(
                                () {},
                              );
                            },
                          );

                          setState(() {});
                        },
                        child: const Text(
                          '4x',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _timeController
                              .setSpeed(
                            speed:
                                TimeSpeed
                                    .x24,
                            playerState:
                                game.player,
                            world:
                                game.world,
                            onTick: () {
                              setState(
                                () {},
                              );
                            },
                          );

                          setState(() {});
                        },
                        child: const Text(
                          '24x',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _travelTo(
    City city,
  ) async {
    final confirmed =
        await showDialog<bool>(
      context: context,
      builder: (_) =>
          TravelConfirmationDialog(
        playerState: game.player,
        destination: city,
      ),
    );

    if (confirmed != true) {
      return;
    }

    TravelService.startTravel(
      playerState: game.player,
      destination: city,
    );

    setState(() {});
  }
}