import 'package:flutter/material.dart';

import '../data/game_data.dart';
import '../core/economy/labour_service.dart';
import '../core/economy/pricing_service.dart';
import '../core/world/time_service.dart';
import '../data/goods_data.dart';
import '../core/models/good.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({
    super.key,
  });

  @override
  State<DebugScreen> createState() =>
      _DebugScreenState();
}

class _DebugScreenState
    extends State<DebugScreen> {
  double totalProducedPerDay(
    Good good,
  ) {
    double total = 0;

    for (final city
        in game.world.cities) {
      for (final industry
          in city.industries) {
        total +=
            (industry.type
                        .outputsPerSize[
                    good] ??
                0) *
            industry.size;
      }
    }

    return total;
  }

  double totalConsumedPerDay(
    Good good,
  ) {
    double total = 0;

    for (final city
        in game.world.cities) {
      for (final industry
          in city.industries) {
        total +=
            (industry.type
                        .inputsPerSize[
                    good] ??
                0) *
            industry.size;
      }

      switch (good.id) {
        case 'Bread':
          total +=
              city.population *
              0.01;
          break;

        case 'Water':
          total +=
              city.population *
              0.01;
          break;

        case 'Wood':
          total +=
              city.population *
              0.002;
          break;

        case 'Tools':
          total +=
              city.population *
              0.001;
          break;
      }
    }

    return total;
  }

  double totalWorldStock(
    Good good,
  ) {
    double total = 0;

    for (final city
        in game.world.cities) {
      total += city
          .marketForGood(good)
          .quantity;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    final city =
        game.player.currentCity;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Debug',
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
            ),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: ListView(
        padding:
            const EdgeInsets.all(16),
        children: [
          if (city != null) ...[
            Text(
              city.name,
              style:
                  const TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Population: ${city.population}',
            ),
            Text(
              'Industries: ${city.industries.length}',
            ),
            Text(
              'Labour Efficiency: '
              '${(LabourService.cityEfficiency(city: city) * 100).toStringAsFixed(0)}%',
            ),
            const SizedBox(
              height: 24,
            ),
          ],

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    TimeService.advanceTime(
                      playerState:
                          game.player,
                      world: game.world,
                      hours: 1,
                    );
                  });
                },
                child: const Text(
                  'Wait 1 Hour',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    TimeService.advanceTime(
                      playerState:
                          game.player,
                      world: game.world,
                      hours: 24,
                    );
                  });
                },
                child: const Text(
                  'Wait 24 Hours',
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 24,
          ),

          const Text(
            'World Economy',
            style: TextStyle(
              fontSize: 22,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const Divider(),

          ...goods.map((good) {
            final produced =
                totalProducedPerDay(
              good,
            );

            final consumed =
                totalConsumedPerDay(
              good,
            );

            final net =
                produced - consumed;

            final stock =
                totalWorldStock(
              good,
            );

            return Card(
              child: Padding(
                padding:
                    const EdgeInsets.all(
                  12,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      good.name,
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight
                                .bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'World Stock: ${stock.toStringAsFixed(1)}',
                    ),
                    Text(
                      'Produced/day: ${produced.toStringAsFixed(1)}',
                    ),
                    Text(
                      'Consumed/day: ${consumed.toStringAsFixed(1)}',
                    ),
                    Text(
                      'Net/day: ${net >= 0 ? '+' : ''}${net.toStringAsFixed(1)}',
                      style: TextStyle(
                        color:
                            net >= 0
                                ? Colors.green
                                : Colors.red,
                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(
            height: 24,
          ),

          const Text(
            'All Cities',
            style: TextStyle(
              fontSize: 22,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const Divider(),

          ...game.world.cities.map(
            (city) => Card(
              child: Padding(
                padding:
                    const EdgeInsets.all(
                  12,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      city.name,
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight
                                .bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Population: ${city.population}',
                    ),
                    Text(
                      'Industries: ${city.industries.length}',
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ...goods.map((good) {
                      final market =
                          city.marketForGood(
                        good,
                      );

                      final price =
                          PricingService
                              .calculatePrice(
                        market: market,
                      );

                      return Text(
                        '${good.name}: '
                        '${market.quantity.toStringAsFixed(1)} '
                        '@ ${price.toStringAsFixed(2)}',
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),

          if (city != null) ...[
            const SizedBox(
              height: 24,
            ),

            const Text(
              'Current City Industries',
              style: TextStyle(
                fontSize: 22,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const Divider(),

            ...city.industries.map(
              (industry) => Card(
                child: Padding(
                  padding:
                      const EdgeInsets.all(
                    12,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        industry.type.name,
                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),
                      Text(
                        'Size: ${industry.size}',
                      ),
                      Text(
                        'Input Target Days: '
                        '${industry.inputDaysTarget}',
                      ),
                      Text(
                        'Storage: '
                        '${industry.currentStorage.toStringAsFixed(1)}'
                        ' / '
                        '${industry.storageCapacity.toStringAsFixed(1)}',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Text(
                        'Inventory',
                        style:
                            TextStyle(
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),
                      if (industry
                          .inventory
                          .isEmpty)
                        const Text(
                          'Empty',
                        ),
                      ...industry
                          .inventory
                          .map(
                        (item) => Text(
                          '${item.good.name}: '
                          '${item.quantity.toStringAsFixed(1)}',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}