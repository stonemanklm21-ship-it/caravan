import 'package:flutter/material.dart';

import '../core/economy/industry_ownership_service.dart';
import '../data/game_data.dart';
import '../ui/theme/app_colors.dart';
import '../ui/widgets/app_card.dart';
import '../ui/widgets/app_tab_view.dart';
import '../ui/widgets/game_scaffold.dart';
import '../ui/widgets/game_status_bar.dart';
import '../ui/widgets/status_item.dart';

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

    return GameScaffold(
      title: 'Industries',
      statusBar: GameStatusBar(
        children: [
          StatusItem(
            icon: '🪙',
            value: game.player.caravan.gold
                .toStringAsFixed(0),
            color: AppColors.gold,
          ),
        ],
      ),
      child: city == null
          ? const Center(
              child: Text(
                'No industries available in the wilderness.',
              ),
            )
          : AppTabView(
              tabs: const [
                'City Industries',
                'Your Industries',
              ],
              children: [
                // City Industries
                ListView(
                  padding: EdgeInsets.zero,
                  children: city.industries
                      .where(
                        (industry) =>
                            !industry.playerOwned,
                      )
                      .map(
                    (industry) {
                      final purchasePrice =
                          IndustryOwnershipService
                              .purchasePrice(
                        industry,
                      );

                      return AppCard(
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
                              'Cash: ${industry.cash.toStringAsFixed(0)}',
                            ),

                            Text(
                              'Profit: ${industry.lastProfit.toStringAsFixed(1)}',
                              style:
                                  TextStyle(
                                color: industry
                                            .lastProfit >=
                                        0
                                    ? Colors
                                        .green
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

                            const SizedBox(
                              height: 12,
                            ),

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
                                  setState(
                                    () {},
                                  );
                                }
                              },
                              child: Text(
                                'Buy (${purchasePrice.toStringAsFixed(0)}g)',
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
                                '${item.good.name}: ${item.quantity.toStringAsFixed(1)}',
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ).toList(),
                ),

                // Your Industries
                ListView(
                  padding: EdgeInsets.zero,
                  children: city.industries
                      .where(
                        (industry) =>
                            industry.playerOwned,
                      )
                      .map(
                    (industry) {
                      return AppCard(
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
                              'Cash: ${industry.cash.toStringAsFixed(0)}',
                            ),

                            Text(
                              'Profit: ${industry.lastProfit.toStringAsFixed(1)}',
                              style:
                                  TextStyle(
                                color: industry
                                            .lastProfit >=
                                        0
                                    ? Colors
                                        .green
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

                            const SizedBox(
                              height: 12,
                            ),

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
                                  setState(
                                    () {},
                                  );
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
                                '${item.good.name}: ${item.quantity.toStringAsFixed(1)}',
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
    );
  }
}