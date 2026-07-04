import 'package:flutter/material.dart';

import '../data/game_data.dart';
import '../core/save/save_service.dart';
import '../core/world/time_service.dart';

import 'debug_screen.dart';
import 'industries_screen.dart';
import 'ledger_screen.dart';
import 'map_screen.dart';
import 'market_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({
    super.key,
  });

  @override
  State<MainMenuScreen> createState() =>
      _MainMenuScreenState();
}

class _MainMenuScreenState
    extends State<MainMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Merchant Caravan Simulator',
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
              'Current Location: '
              '${game.player.currentCity?.name ?? 'Wilderness'}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Day ${game.player.day}, '
              '${game.player.hour.toString().padLeft(2, '0')}:00',
            ),

            Text(
              'World Time: '
              '${game.player.worldTimeHours.toStringAsFixed(2)} h',
            ),

            const SizedBox(height: 8),

            Text(
              'Gold: ${game.player.caravan.gold.toStringAsFixed(2)}',
            ),

            Text(
              'Speed: ${game.player.caravan.speed.toStringAsFixed(2)}',
            ),

            Text(
              'Cargo: '
              '${game.player.caravan.cargoWeightKg.toStringAsFixed(1)}kg'
              ' / '
              '${game.player.caravan.cargoCapacityKg.toStringAsFixed(1)}kg',
            ),

            const SizedBox(height: 24),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const MarketScreen(),
                      ),
                    ).then(
                      (_) => setState(() {}),
                    );
                  },
                  child: const Text(
                    'Market',
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const IndustriesScreen(),
                      ),
                    ).then(
                      (_) => setState(() {}),
                    );
                  },
                  child: const Text(
                    'Industries',
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const LedgerScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Ledger',
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const MapScreen(),
                      ),
                    ).then(
                      (_) => setState(() {}),
                    );
                  },
                  child: const Text(
                    'Map',
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const DebugScreen(),
                      ),
                    ).then(
                      (_) => setState(() {}),
                    );
                  },
                  child: const Text(
                    'Debug',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await SaveService.save(
                      game,
                    );

                    if (!mounted) {
                      return;
                    }

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Game saved',
                        ),
                      ),
                    );
                  },
                  child:
                      const Text('Save'),
                ),

                ElevatedButton(
                  onPressed: () async {
                    final loaded =
                        await SaveService.load();

                    if (loaded == null) {
                      if (!mounted) {
                        return;
                      }

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'No save found',
                          ),
                        ),
                      );

                      return;
                    }

                    game.world =
                        loaded.world;

                    game.player =
                        loaded.player;

                    setState(() {});

                    if (!mounted) {
                      return;
                    }

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Game loaded',
                        ),
                      ),
                    );
                  },
                  child:
                      const Text('Load'),
                ),
              ],
            ),

            const SizedBox(height: 24),

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
          ],
        ),
      ),
    );
  }
}