import 'package:flutter/material.dart';

import '../core/models/city.dart';
import '../core/models/game_state.dart';
import '../core/travel/journey_route_painter.dart';
import '../core/travel/journey_service.dart';
import '../core/travel/travel_service.dart';
import '../core/world/time_controller.dart';
import '../core/world/time_speed.dart';
import '../data/cities_data.dart';
import '../data/world_data.dart';

class MapScreen extends StatefulWidget {
  final GameState gameState;

  const MapScreen({
    super.key,
    required this.gameState,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const double cityIconRadius = 16;
  static const double caravanIconRadius = 20;

  final TimeController _timeController =
      TimeController();

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('World Map'),
      ),
      body: Stack(
        children: [
          CustomPaint(
            size: Size.infinite,
            painter: JourneyRoutePainter(
              gameState: widget.gameState,
            ),
          ),

          ...cities.map(
            (city) => Positioned(
              left: city.x - cityIconRadius,
              top: city.y - cityIconRadius,
              child: GestureDetector(
                onTap: () => _travelTo(city),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_city,
                      size: 32,
                    ),
                    Text(city.name),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            left:
                JourneyService.currentX(
                      widget.gameState,
                    ) -
                    caravanIconRadius,
            top:
                JourneyService.currentY(
                      widget.gameState,
                    ) -
                    caravanIconRadius,
            child: const Icon(
              Icons.person_pin_circle,
              color: Colors.red,
              size: 40,
            ),
          ),

          Positioned(
            left: 16,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Day ${widget.gameState.day}',
                  ),

                  Text(
                    '${widget.gameState.hour.toString().padLeft(2, '0')}:00',
                  ),

                  Text(
                    'Speed: ${_timeController.currentSpeed.name}',
                  ),

                  const SizedBox(height: 8),

                  if (widget.gameState.activeJourney !=
                      null) ...[
                    Text(
                      'Destination: '
                      '${widget.gameState.activeJourney!.destination.name}',
                    ),

                    Text(
                      'Progress: '
                      '${(widget.gameState.activeJourney!.progress * 100).toStringAsFixed(0)}%',
                    ),

                    Text(
                      'Remaining: '
                      '${widget.gameState.activeJourney!.remainingHours.toStringAsFixed(1)}h',
                    ),

                    const SizedBox(height: 8),
                  ],

                  Text(
                    'X: ${JourneyService.currentX(widget.gameState).toStringAsFixed(1)}',
                  ),

                  Text(
                    'Y: ${JourneyService.currentY(widget.gameState).toStringAsFixed(1)}',
                  ),

                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _timeController.setSpeed(
                            speed: TimeSpeed.paused,
                            gameState:
                                widget.gameState,
                            world: world,
                            onTick: () {
                              setState(() {});
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
                          _timeController.setSpeed(
                            speed: TimeSpeed.x1,
                            gameState:
                                widget.gameState,
                            world: world,
                            onTick: () {
                              setState(() {});
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
                          _timeController.setSpeed(
                            speed: TimeSpeed.x4,
                            gameState:
                                widget.gameState,
                            world: world,
                            onTick: () {
                              setState(() {});
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
                          _timeController.setSpeed(
                            speed: TimeSpeed.x24,
                            gameState:
                                widget.gameState,
                            world: world,
                            onTick: () {
                              setState(() {});
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

  void _travelTo(City city) {
    TravelService.startTravel(
      gameState: widget.gameState,
      destination: city,
    );

    setState(() {});
  }
}