import 'package:flutter/material.dart';

import '../core/city/vehicle_repair_service.dart';
import '../core/models/player_state.dart';
import '../core/models/vehicle.dart';

class CartwrightScreen
    extends StatefulWidget {
  final PlayerState playerState;

  const CartwrightScreen({
    super.key,
    required this.playerState,
  });

  @override
  State<CartwrightScreen> createState() =>
      _CartwrightScreenState();
}

class _CartwrightScreenState
    extends State<CartwrightScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cartwright',
        ),
      ),
      body: ListView.builder(
        itemCount: widget
            .playerState
            .caravan
            .vehicles
            .length,
        itemBuilder:
            (context, index) {
          final vehicle = widget
              .playerState
              .caravan
              .vehicles[index];

          final cost =
              VehicleRepairService
                  .repairCost(
            vehicle,
          );

          return _vehicleCard(
            vehicle: vehicle,
            cost: cost,
          );
        },
      ),
    );
  }

  Widget _vehicleCard({
    required Vehicle vehicle,
    required double cost,
  }) {
    final canRepair =
        VehicleRepairService
                .canRepair(
          vehicle,
        ) &&
        widget.playerState
                .caravan.gold >=
            cost;

    return Card(
      margin:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: Padding(
        padding:
            const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              vehicle.type.name,
              style:
                  const TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              'Condition: '
              '${vehicle.condition.toStringAsFixed(0)}'
              ' / '
              '${vehicle.type.maxCondition.toStringAsFixed(0)}',
            ),

            Text(
              'Max Cargo: '
              '${vehicle.type.maxCargoKg.toStringAsFixed(1)} kg',
            ),

            Text(
              'Repair Cost: '
              '${cost.toStringAsFixed(0)}',
            ),

            const SizedBox(
              height: 8,
            ),

            ElevatedButton(
              onPressed:
                  canRepair
                      ? () {
                          setState(() {
                            widget
                                .playerState
                                .caravan
                                .gold -= cost;

                            VehicleRepairService
                                .repair(
                              vehicle,
                            );
                          });
                        }
                      : null,
              child: Text(
                VehicleRepairService
                        .canRepair(
                  vehicle,
                )
                    ? 'Repair'
                    : 'Fully Repaired',
              ),
            ),
          ],
        ),
      ),
    );
  }
}