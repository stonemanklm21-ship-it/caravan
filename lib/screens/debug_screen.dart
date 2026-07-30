import 'package:flutter/material.dart';

import '../data/game_data.dart';
import '../core/economy/labour_service.dart';
import '../core/economy/pricing_service.dart';
import '../core/world/time_service.dart';
import '../data/goods_data.dart';
import '../core/models/good.dart';
import '../core/economy/trade_analytics.dart';
import '../core/world/time_controller.dart';
import '../core/world/time_speed.dart';

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
  final TimeController _timeController =
      TimeController();

  void _setSpeed(TimeSpeed speed) {
    _timeController.setSpeed(
      speed: speed,
      playerState: game.player,
      world: game.world,
      onTick: () {
        if (mounted) {
          setState(() {});
        }
      },
    );

    setState(() {});
  }

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
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
              Text(
                'Speed: ${_timeController.currentSpeed.name}',
              ),
              ElevatedButton(
                onPressed: () =>
                    _setSpeed(
                  TimeSpeed.paused,
                ),
                child:
                    const Text('Pause'),
              ),
              ElevatedButton(
                onPressed: () =>
                    _setSpeed(
                  TimeSpeed.x1,
                ),
                child:
                    const Text('1x'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    TimeService.advanceTime(
                      playerState:
                          game.player,
                      world:
                          game.world,
                      hours: 1,
                      tickFraction: 0,
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
                      world:
                          game.world,
                      hours: 24,
                      tickFraction: 0,
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
                TradeAnalytics
                        .produced[
                    good.id] ??
                0;

            final consumed =
                TradeAnalytics
                        .consumed[
                    good.id] ??
                0;

            final unmetDemand =
                TradeAnalytics
                        .unmetDemand[
                    good.id] ??
                0;

final transported =
    TradeAnalytics.transported[
            good.id] ??
        0;

final desiredConsumption =
    TradeAnalytics
            .desiredConsumption[
        good.id] ??
    0;

    final fulfilment =
    desiredConsumption > 0
        ? (consumed /
                desiredConsumption) *
            100
        : 100;

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
                      'Produced: ${produced.toStringAsFixed(1)}',
                    ),
                    Text(
                      'Consumed: ${consumed.toStringAsFixed(1)}',
                    ),
                                        Text(
                      'Transported: ${transported.toStringAsFixed(1)}',
                    ),
                    Text(
                      'Industry Shortfall: ${unmetDemand.toStringAsFixed(1)}',
                      style:
                          TextStyle(
                        color:
                            unmetDemand >
                                    0
                                ? Colors
                                    .orange
                                : Colors
                                    .green,
                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),
                    Text(
  'Desired Consumption: ${desiredConsumption.toStringAsFixed(1)}',
),
Text(
  'Consumption Fulfilment: ${fulfilment.toStringAsFixed(0)}%',
  style: TextStyle(
    color: fulfilment < 50
        ? Colors.red
        : fulfilment < 90
            ? Colors.orange
            : Colors.green,
    fontWeight: FontWeight.bold,
  ),
),
                    Text(
                      'Net: ${net >= 0 ? '+' : ''}${net.toStringAsFixed(1)}',
                      style:
                          TextStyle(
                        color:
                            net >= 0
                                ? Colors
                                    .green
                                : Colors
                                    .red,
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
                        city: city,
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
                      Text(
                        'Cash: ${industry.cash.toStringAsFixed(0)}',
                      ),
                      Text(
                        'Revenue: ${industry.lastRevenue.toStringAsFixed(1)}',
                      ),
                      Text(
                        'Expenses: ${industry.lastExpenses.toStringAsFixed(1)}',
                      ),
                      Text(
                        'Profit: ${industry.lastProfit.toStringAsFixed(1)}',
                        style:
                            TextStyle(
                          color: industry
                                      .lastProfit >=
                                  0
                              ? Colors.green
                              : Colors.red,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Lifetime Revenue: ${industry.lifetimeRevenue.toStringAsFixed(0)}',
                      ),
                      Text(
                        'Lifetime Expenses: ${industry.lifetimeExpenses.toStringAsFixed(0)}',
                      ),
                      Text(
                        'Lifetime Profit: ${industry.lifetimeProfit.toStringAsFixed(0)}',
                        style:
                            TextStyle(
                          color: industry
                                      .lifetimeProfit >=
                                  0
                              ? Colors.green
                              : Colors.red,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
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