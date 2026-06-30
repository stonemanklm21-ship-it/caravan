import 'package:flutter/material.dart';

import 'map_screen.dart';
import '../core/economy/pricing_service.dart';
import '../core/economy/trading_service.dart';
import '../core/models/caravan.dart';
import '../core/models/caravan_component_stack.dart';
import '../core/models/game_state.dart';
import '../core/world/time_service.dart';
import '../data/caravan_components_data.dart';
import '../data/cities_data.dart';
import '../data/goods_data.dart';
import '../data/world_data.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  final GameState gameState = GameState(
    worldTimeHours: 1,
    currentCity: farmingVillage,
    worldX: farmingVillage.x,
    worldY: farmingVillage.y,
    caravan: Caravan(
      gold: 100,
      inventory: [],
      components: [
        CaravanComponentStack(
          component: player,
          quantity: 1,
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Merchant Caravan Simulator (Debug)',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current City: ${gameState.currentCity.name}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Day ${gameState.day}, '
              '${gameState.hour.toString().padLeft(2, '0')}:00',
            ),

            Text(
              'World Time: ${gameState.worldTimeHours.toStringAsFixed(2)} h',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            if (gameState.activeJourney != null) ...[
              const SizedBox(height: 8),
              Text(
                'Journey Destination: '
                '${gameState.activeJourney!.destination.name}',
              ),
              Text(
                'Journey Progress: '
                '${(gameState.activeJourney!.progress * 100).toStringAsFixed(0)}%',
              ),
              Text(
                'Journey Remaining: '
                '${gameState.activeJourney!.remainingHours.toStringAsFixed(1)}h',
              ),
            ],

            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MapScreen(
                      gameState: gameState,
                    ),
                  ),
                ).then((_) {
                  setState(() {});
                });
              },
              child: const Text('Open Map'),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      TimeService.advanceTime(
                        gameState: gameState,
                        world: world,
                        hours: 1,
                      );
                    });
                  },
                  child: const Text('Wait 1 Hour'),
                ),

                const SizedBox(width: 8),

                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      TimeService.advanceTime(
                        gameState: gameState,
                        world: world,
                        hours: 24,
                      );
                    });
                  },
                  child: const Text('Wait 24 Hours'),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              'Gold: ${gameState.caravan.gold.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            Text(
              'Speed: ${gameState.caravan.speed.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            Text(
              'Cargo: '
              '${gameState.caravan.cargoWeightKg.toStringAsFixed(1)}kg'
              ' / '
              '${gameState.caravan.cargoCapacityKg.toStringAsFixed(1)}kg',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),

            Text(
              'Calories/day: '
              '${gameState.caravan.calorieRequirementPerDay.toStringAsFixed(0)}',
            ),

            Text(
              'Water/day: '
              '${gameState.caravan.waterRequirementPerDay.toStringAsFixed(1)}',
            ),

            Text(
              'Forage/day: '
              '${gameState.caravan.forageRequirementPerDay.toStringAsFixed(1)}',
            ),

            const SizedBox(height: 24),

            const Text(
              'Market',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Divider(),

            Expanded(
              child: ListView(
                children: goods.map((good) {
                  final market =
                      gameState.currentCity
                          .marketForGood(good);

                  final price =
                      PricingService.calculatePrice(
                    market: market,
                  );

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${good.name}\n'
                              'Price: ${price.toStringAsFixed(2)}g\n'
                              'Weight: ${good.weight}kg\n'
                              'Calories: ${good.caloriesPerUnit.toStringAsFixed(0)}\n'
                              'Supply: ${market.supply.toStringAsFixed(1)}\n'
                              'Demand: ${market.demand.toStringAsFixed(1)}\n'
                              'Production/day: ${market.productionPerDay}\n'
                              'Consumption/day: ${market.consumptionPerDay}',
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                TradingService.buy(
                                  caravan:
                                      gameState.caravan,
                                  market: market,
                                  quantity: 1,
                                );
                              });
                            },
                            child: const Text('Buy'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                TradingService.sell(
                                  caravan:
                                      gameState.caravan,
                                  market: market,
                                  quantity: 1,
                                );
                              });
                            },
                            child: const Text('Sell'),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const Divider(),

            const Text(
              'Caravan',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            ...gameState.caravan.components.map(
              (stack) => Text(
                '${stack.component.name} x${stack.quantity}',
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Inventory',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            if (gameState.caravan.inventory.isEmpty)
              const Text('Empty'),

            ...gameState.caravan.inventory.map(
              (item) => Text(
                '${item.good.name} x${item.quantity}'
                ' (${item.totalWeightKg.toStringAsFixed(1)}kg)',
              ),
            ),
          ],
        ),
      ),
    );
  }
}