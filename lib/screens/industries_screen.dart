import 'package:flutter/material.dart';

import '../data/game_data.dart';
import '../core/economy/industry_ownership_service.dart';

class IndustriesScreen extends StatefulWidget {
  const IndustriesScreen({
    super.key,
  });

  @override
  State<IndustriesScreen> createState() =>
      _IndustriesScreenState();
}

class _IndustriesScreenState
    extends State<IndustriesScreen> {
  @override
  Widget build(BuildContext context) {
    final city =
        game.player.currentCity;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Industries',
        ),
      ),
      body: city == null
          ? const Center(
              child: Text(
                'No industries available in the wilderness.',
              ),
            )
          : ListView(
              padding:
                  const EdgeInsets.all(16),
              children:
                  city.industries.map(
                (industry) {
                  final purchasePrice =
                      IndustryOwnershipService
                          .purchasePrice(
                    industry,
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
                            industry.type.name,
                            style:
                                const TextStyle(
                              fontSize: 20,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),

                          const SizedBox(
                            height: 8,
                          ),

                          Text(
                            'Owned: ${industry.playerOwned ? 'Yes' : 'No'}',
                          ),

                          Text(
                            'Cash: ${industry.cash.toStringAsFixed(0)}',
                          ),

                          Text(
                            'Profit: ${industry.lastProfit.toStringAsFixed(1)}',
                            style: TextStyle(
                              color:
                                  industry.lastProfit >=
                                          0
                                      ? Colors.green
                                      : Colors.red,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),

                          Text(
                            'Lifetime Profit: ${industry.lifetimeProfit.toStringAsFixed(0)}',
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
                            height: 12,
                          ),

                          if (!industry
                              .playerOwned)
                            ElevatedButton(
                              onPressed: () {
                                final success =
                                    IndustryOwnershipService
                                        .buyIndustry(
                                  caravan: game
                                      .player
                                      .caravan,
                                  industry:
                                      industry,
                                );

                                if (success) {
                                  setState(() {});
                                }
                              },
                              child: Text(
                                'Buy (${purchasePrice.toStringAsFixed(0)}g)',
                              ),
                            ),

                          if (industry
                              .playerOwned)
                            ElevatedButton(
                              onPressed: () {
                                final success =
                                    IndustryOwnershipService
                                        .collectCash(
                                  caravan: game
                                      .player
                                      .caravan,
                                  industry:
                                      industry,
                                );

                                if (success) {
                                  setState(() {});
                                }
                              },
                              child: const Text(
                                'Collect Cash',
                              ),
                            ),

                          const SizedBox(
                            height: 12,
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
                  );
                },
              ).toList(),
            ),
    );
  }
}