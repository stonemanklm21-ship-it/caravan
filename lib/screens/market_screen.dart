import 'package:flutter/material.dart';

import '../data/game_data.dart';
import '../core/economy/pricing_service.dart';
import '../core/economy/trading_service.dart';
import '../data/goods_data.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({
    super.key,
  });

  @override
  State<MarketScreen> createState() =>
      _MarketScreenState();
}

class _MarketScreenState
    extends State<MarketScreen> {
  @override
  Widget build(BuildContext context) {
    final city =
        game.player.currentCity;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Market',
        ),
      ),
      body: city == null
          ? const Center(
              child: Text(
                'No market available in the wilderness.',
              ),
            )
          : Padding(
              padding:
                  const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    city.name,
                    style:
                        const TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  Expanded(
                    child: ListView(
                      children:
                          goods.map(
                        (good) {
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

                          return Card(
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(
                                12,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${good.name}\n'
                                      'Price: ${price.toStringAsFixed(2)}g\n'
                                      'Available: ${market.quantity.toStringAsFixed(1)}',
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed:
                                        () {
                                      setState(
                                        () {
                                          TradingService
                                              .buy(
                                                city: city,
                                            caravan:
                                                game.player.caravan,
                                            market:
                                                market,
                                            quantity:
                                                1,
                                          );
                                        },
                                      );
                                    },
                                    child:
                                        const Text(
                                      'Buy',
                                    ),
                                  ),
                                  const SizedBox(
                                    width:
                                        8,
                                  ),
                                  ElevatedButton(
                                    onPressed:
                                        () {
                                      setState(
                                        () {
                                          TradingService
                                              .sell(
                                                city: city,
                                            caravan:
                                                game.player.caravan,
                                            market:
                                                market,
                                            quantity:
                                                1,
                                          );
                                        },
                                      );
                                    },
                                    child:
                                        const Text(
                                      'Sell',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),

                  const Divider(),

                  const Text(
                    'Inventory',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  if (game
                      .player
                      .caravan
                      .inventory
                      .isEmpty)
                    const Text(
                      'Empty',
                    ),

                  ...game.player.caravan
                      .inventory
                      .map(
                    (item) => Text(
                      '${item.good.name} x${item.quantity.toStringAsFixed(2)} '
                      '(${item.totalWeightKg.toStringAsFixed(1)}kg)',
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}