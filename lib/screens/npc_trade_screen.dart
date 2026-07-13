import 'package:flutter/material.dart';

import '../core/economy/pricing_service.dart';
import '../core/economy/trading_service.dart';
import '../core/world/location_service.dart';
import '../data/game_data.dart';
import '../core/models/npc_caravan.dart';

class NpcTradeScreen extends StatefulWidget {
  final NpcCaravan npc;

  const NpcTradeScreen({
    super.key,
    required this.npc,
  });

  @override
  State<NpcTradeScreen> createState() =>
      _NpcTradeScreenState();
}

class _NpcTradeScreenState
    extends State<NpcTradeScreen> {
  @override
  Widget build(BuildContext context) {
    final city =
        LocationService.nearestCity(
      world: game.world,
      x: widget.npc.worldX,
      y: widget.npc.worldY,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Merchant Caravan',
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              'Nearest market: ${city.name}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: ListView(
                children: widget
                    .npc.caravan.inventory
                    .map((item) {
                  final market =
                      city.marketForGood(
                    item.good,
                  );

                  final buyPrice =
                      PricingService
                          .npcSellPrice(
                    city: city,
                    market: market,
                  );

                  final sellPrice =
                      PricingService
                          .npcBuyPrice(
                    city: city,
                    market: market,
                  );

                  return Card(
                    child: Padding(
                      padding:
                          const EdgeInsets
                              .all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${item.good.name}\n'
                              'Stock: ${item.quantity.toStringAsFixed(0)}\n'
                              'Buy: ${buyPrice.toStringAsFixed(2)}g\n'
                              'Sell: ${sellPrice.toStringAsFixed(2)}g',
                            ),
                          ),
                          Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    TradingService
                                        .buyFromNpc(
                                      player: game
                                          .player
                                          .caravan,
                                      npc: widget
                                          .npc
                                          .caravan,
                                      item: item,
                                      quantity: 1,
                                      unitPrice:
                                          buyPrice,
                                    );
                                  });
                                },
                                child:
                                    const Text(
                                  'Buy',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}