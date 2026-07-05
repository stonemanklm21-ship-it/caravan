import 'package:flutter/material.dart';

import '../../core/economy/vehicle_market_service.dart';
import '../../core/models/player_state.dart';
import '../../core/models/vehicle.dart';

class VehicleMarketScreen
    extends StatefulWidget {
  final PlayerState playerState;

  final VehicleMarketTier tier;

  const VehicleMarketScreen({
    super.key,
    required this.playerState,
    required this.tier,
  });

  @override
  State<VehicleMarketScreen>
      createState() =>
          _VehicleMarketScreenState();
}

class _VehicleMarketScreenState
    extends State<VehicleMarketScreen> {
  late List<Vehicle> stock;

  @override
  void initState() {
    super.initState();

    stock =
        VehicleMarketService.generateStock(
      tier: widget.tier,
      stockSize: 8,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vehicle Dealer',
        ),
      ),
      body: ListView.builder(
        itemCount: stock.length,
        itemBuilder:
            (context, index) {
          final vehicle =
              stock[index];

          final price =
              VehicleMarketService
                  .price(
            vehicle,
          );

          return Card(
            margin:
                const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            child: ListTile(
              title: Text(
                vehicle.type.name,
              ),
              subtitle: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    'Condition: '
                    '${vehicle.condition.toStringAsFixed(0)}'
                    ' / '
                    '${vehicle.type.maxCondition.toStringAsFixed(0)}',
                  ),
                  Text(
                    'Pull Requirement: '
                    '${vehicle.type.requiredPullingCapacityKg.toStringAsFixed(1)} kg',
                  ),
                  Text(
                    'Max Cargo: '
                    '${vehicle.type.maxCargoKg.toStringAsFixed(1)} kg',
                  ),
                  Text(
                    'Multiplier: '
                    '${vehicle.type.capacityMultiplier.toStringAsFixed(1)}x',
                  ),
                  Text(
                    'Price: '
                    '${price.toStringAsFixed(0)}',
                  ),
                ],
              ),
              trailing: ElevatedButton(
                onPressed:
                    widget
                                .playerState
                                .caravan
                                .gold <
                            price
                        ? null
                        : () {
                            setState(() {
                              widget
                                      .playerState
                                      .caravan
                                      .gold -=
                                  price;

                              widget
                                  .playerState
                                  .caravan
                                  .vehicles
                                  .add(
                                    vehicle,
                                  );

                              stock.removeAt(
                                index,
                              );
                            });
                          },
                child: const Text(
                  'Buy',
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}