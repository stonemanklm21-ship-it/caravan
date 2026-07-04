import 'package:flutter/material.dart';

import '../data/game_data.dart';

class IndustriesScreen extends StatelessWidget {
  const IndustriesScreen({
    super.key,
  });

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

                          const Text(
                            'Inventory',
                            style:
                                TextStyle(
                              fontWeight:
                                  FontWeight.bold,
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