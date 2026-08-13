import 'package:flutter/material.dart';

import '../core/economy/pricing_service.dart';
import '../core/economy/trading_service.dart';
import '../core/ledger/ledger_service.dart';
import '../data/game_data.dart';
import '../data/goods_data.dart';
import '../ui/theme/app_colors.dart';
import '../ui/theme/app_text_styles.dart';
import '../ui/widgets/app_card.dart';
import '../ui/widgets/game_scaffold.dart';
import '../ui/widgets/game_status_bar.dart';
import '../ui/widgets/market_button.dart';
import '../ui/widgets/status_item.dart';

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
  void initState() {
    super.initState();

    final city = game.player.currentCity;

    if (city == null) {
      return;
    }

    for (final good in goods) {
      final market = city.marketForGood(good);

      LedgerService.recordObservation(
        playerState: game.player,
        cityId: city.id,
        goodId: good.id,
        price: PricingService.calculatePrice(
          market: market,
          city: city,
        ),
      );

      print(
  'Ledger observations: '
  '${game.player.ledger.observations.length}',
);
    }
  }
      
  @override
  Widget build(BuildContext context) {
    final city =
        game.player.currentCity;

    if (city == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'No market available in the wilderness.',
          ),
        ),
      );
    }

    final caravan =
        game.player.caravan;

    return GameScaffold(
      title: 'Market',
      statusBar: GameStatusBar(
        children: [
                    StatusItem(
            icon: '🎒',
            value:
                '${caravan.cargoWeightKg.toStringAsFixed(1)}/${caravan.cargoCapacityKg.toStringAsFixed(1)}kg',
            color: AppColors.gold,
          ),
          StatusItem(
            icon: '🪙',
            value: caravan.gold
                .toStringAsFixed(0),
            color: AppColors.gold,
          ),

        ],
      ),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 110,
                  child: Text(
                    'Buy',
                    textAlign:
                        TextAlign.center,
                   style: AppTextStyles.section.copyWith(
  color: AppColors.gold,
),             
                  ),
                ),
                Expanded(
                  child: Text(
                    'Good',
                    textAlign:
                        TextAlign.center,
                style: AppTextStyles.section.copyWith(
  color: AppColors.gold,
),       
                  ),
                ),
                SizedBox(
                  width: 110,
                  child: Text(
                    'Sell',
                    textAlign:
                        TextAlign.center,
                     style: AppTextStyles.section.copyWith(
  color: AppColors.gold,
),       
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: goods.length,
              itemBuilder:
                  (context, index) {
                final good =
                    goods[index];

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

                final item = caravan
                    .inventory
                    .cast<dynamic>()
                    .firstWhere(
                      (item) =>
                          item
                              ?.good.id ==
                          good.id,
                      orElse:
                          () => null,
                    );

                final owned =
                    item?.quantity ??
                        0.0;

                return AppCard(
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Expanded(
                        
                        child: Column(
                          children: [
                            Text(
                              'Qty: ${market.quantity.toStringAsFixed(0)}',
                            ),
                     
                            Row(
                              children: [
                                Expanded(
                                  child:
                                      MarketButton(
                                    text: '1',
                                    onPressed:
                                        () =>
                                            _buy(
                                      city,
                                      market,
                                      1,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Expanded(
                                  child:
                                      MarketButton(
                                    text: '10',
                                    onPressed:
                                        () =>
                                            _buy(
                                      city,
                                      market,
                                      10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child:
                                      MarketButton(
                                    text:
                                        '100',
                                    onPressed:
                                        () =>
                                            _buy(
                                      city,
                                      market,
                                      100,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Expanded(
                                  child:
                                      MarketButton(
                                    text:
                                        'Max',
                                    onPressed:
                                        () =>
                                            _buyMax(
                                      city,
                                      market,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                     SizedBox(
  width: 80,
  child: Column(
    children: [
      Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.gold,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Center(
          child: Icon(
            Icons.inventory_2_outlined,
            size: 18,
          ),
        ),
      ),

      const SizedBox(height: 2),

      Text(
        good.name,
        textAlign: TextAlign.center,
        style: AppTextStyles.section,
      ),

      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            price.toStringAsFixed(1),
            style: AppTextStyles.body,
          ),
          const SizedBox(width: 2),
          const Text('🪙'),
        ],
      ),
    ],
  ),
),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                                                child: Column(
                          children: [
                            Text(
                              'Qty: ${owned.toStringAsFixed(owned % 1 == 0 ? 0 : 2)}',
                            ),
                          
                            Row(
                              children: [
                                Expanded(
                                  child:
                                      MarketButton(
                                    text: '1',
                                    onPressed:
                                        () =>
                                            _sell(
                                      city,
                                      market,
                                      1,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Expanded(
                                  child:
                                      MarketButton(
                                    text: '10',
                                    onPressed:
                                        () =>
                                            _sell(
                                      city,
                                      market,
                                      10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child:
                                      MarketButton(
                                    text:
                                        '100',
                                    onPressed:
                                        () =>
                                            _sell(
                                      city,
                                      market,
                                      100,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Expanded(
                                  child:
                                      MarketButton(
                                    text:
                                        'All',
                                    onPressed:
                                        owned <=
                                                0
                                            ? null
                                            : () =>
                                                _sell(
                                              city,
                                              market,
                                              owned
                                                  .floor(),
                                            ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _buy(
    dynamic city,
    dynamic market,
    int quantity,
  ) {
    setState(() {
      TradingService.buy(
        city: city,
        caravan:
            game.player.caravan,
        market: market,
        quantity: quantity,
      );
    });
  }

  void _sell(
    dynamic city,
    dynamic market,
    int quantity,
  ) {
    setState(() {
      TradingService.sell(
        city: city,
        caravan:
            game.player.caravan,
        market: market,
        quantity: quantity,
      );
    });
  }

  void _buyMax(
    dynamic city,
    dynamic market,
  ) {
    setState(() {
      while (TradingService.buy(
        city: city,
        caravan:
            game.player.caravan,
        market: market,
        quantity: 1,
      )) {}
    });
  }
}