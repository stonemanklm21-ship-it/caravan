import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/caravan/caravan_service.dart';
import '../../core/caravan/vehicle_service.dart';
import '../../core/models/city.dart';
import '../../core/models/player_state.dart';
import '../../core/travel/journey_service.dart';
import '../../data/goods_data.dart';

class TravelConfirmationDialog
    extends StatelessWidget {
  final PlayerState playerState;

  final City? destination;

  final double? destinationX;
  final double? destinationY;

  const TravelConfirmationDialog({
    super.key,
    required this.playerState,
    this.destination,
    this.destinationX,
    this.destinationY,
  }) : assert(
          destination != null ||
              (destinationX != null &&
                  destinationY != null),
          'Provide either a destination city or destination coordinates.',
        );

  @override
  Widget build(BuildContext context) {
    final originX =
        JourneyService.currentX(
      playerState,
    );

    final originY =
        JourneyService.currentY(
      playerState,
    );

    final targetX =
        destination?.x ??
        destinationX!;

    final targetY =
        destination?.y ??
        destinationY!;

    final dx = targetX - originX;
    final dy = targetY - originY;

    final distance = sqrt(
      (dx * dx) + (dy * dy),
    );

    final travelDays =
        distance /
        (JourneyService.mapUnitsPerDay *
            playerState.caravan.speed);

    final travelHours =
        travelDays * 24;

    final caloriesRequired =
        playerState
                .caravan
                .calorieRequirementPerDay *
            travelDays;

    final waterRequired =
        playerState
                .caravan
                .waterRequirementPerDay *
            travelDays;

    final forageRequired =
        playerState
                .caravan
                .forageRequirementPerDay *
            travelDays;

    final fuelRequired = 0.0;

    final availableWater =
        playerState.caravan.quantityOf(
      water.id,
    );

    final availableForage =
        playerState.caravan.quantityOf(
      forage.id,
    );

    final availableFuel = 0.0;

    final availableCalories =
        playerState.caravan.inventory.fold(
      0.0,
      (total, item) =>
          total +
          (item.quantity *
              item.good.caloriesPerUnit),
    );

    final hasWaterShortage =
        availableWater < waterRequired;

    final hasForageShortage =
        availableForage < forageRequired;

    final hasCalorieShortage =
        availableCalories <
            caloriesRequired;

    final hasFuelShortage =
        availableFuel < fuelRequired;

    final hasShortage =
        hasWaterShortage ||
        hasForageShortage ||
        hasCalorieShortage ||
        hasFuelShortage;

    final canTravel =
        CaravanService.canTravel(
      playerState.caravan,
    );

    final usableVehicles =
        playerState.caravan.vehicles
            .where(
              VehicleService.canPull,
            )
            .length;

    return AlertDialog(
      title: Text(
        destination?.name ??
            'Wilderness',
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.all(
                8,
              ),
              decoration:
                  BoxDecoration(
                color: canTravel
                    ? Colors
                        .green
                        .shade100
                    : Colors
                        .red
                        .shade100,
                border: Border.all(
                  color: canTravel
                      ? Colors.green
                      : Colors.red,
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    canTravel
                        ? '✅ Caravan Ready'
                        : '❌ Caravan Not Ready',
                    style:
                        const TextStyle(
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),
                  Text(
                    'Usable Vehicles: '
                    '$usableVehicles / '
                    '${playerState.caravan.vehicles.length}',
                  ),
                  if (!canTravel)
                    const Text(
                      'Assign a sufficiently strong animal to a vehicle before travelling.',
                    ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            if (destination == null)
              Text(
                'Coordinates: '
                '${targetX.toStringAsFixed(0)}, '
                '${targetY.toStringAsFixed(0)}',
              ),
            Text(
              'Travel Time: '
              '${travelHours.toStringAsFixed(1)}h',
            ),
            Text(
              'Distance: '
              '${distance.toStringAsFixed(0)}',
            ),
            const SizedBox(height: 16),
            const Text(
              'Requirements',
              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),
            Text(
              'Calories: '
              '${caloriesRequired.toStringAsFixed(0)}',
            ),
            Text(
              'Water: '
              '${waterRequired.toStringAsFixed(1)}',
            ),
            Text(
              'Forage: '
              '${forageRequired.toStringAsFixed(1)}',
            ),
            Text(
              'Fuel: '
              '${fuelRequired.toStringAsFixed(1)}',
            ),
            const SizedBox(height: 16),
            const Text(
              'Available',
              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),
            Text(
              'Calories: '
              '${availableCalories.toStringAsFixed(0)} '
              '${availableCalories >= caloriesRequired ? '✓' : '✗'}',
            ),
            Text(
              'Water: '
              '${availableWater.toStringAsFixed(1)} '
              '${availableWater >= waterRequired ? '✓' : '✗'}',
            ),
            Text(
              'Forage: '
              '${availableForage.toStringAsFixed(1)} '
              '${availableForage >= forageRequired ? '✓' : '✗'}',
            ),
            Text(
              'Fuel: '
              '${availableFuel.toStringAsFixed(1)} '
              '${availableFuel >= fuelRequired ? '✓' : '✗'}',
            ),
            if (hasShortage) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.all(
                  8,
                ),
                decoration:
                    BoxDecoration(
                  color: Colors
                      .orange.shade100,
                  border: Border.all(
                    color:
                        Colors.orange,
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    const Text(
                      '⚠ WARNING',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),
                    if (hasCalorieShortage)
                      const Text(
                        'Insufficient calories.',
                      ),
                    if (hasWaterShortage)
                      const Text(
                        'Insufficient water.',
                      ),
                    if (hasForageShortage)
                      const Text(
                        'Insufficient forage.',
                      ),
                    if (hasFuelShortage)
                      const Text(
                        'Insufficient fuel.',
                      ),
                    const SizedBox(
                      height: 4,
                    ),
                    const Text(
                      'The caravan may suffer penalties during this journey.',
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(
              context,
              false,
            );
          },
          child:
              const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: canTravel
              ? () {
                  Navigator.pop(
                    context,
                    true,
                  );
                }
              : null,
          child: Text(
            hasShortage
                ? 'Travel Anyway'
                : 'Travel',
          ),
        ),
      ],
    );
  }
}