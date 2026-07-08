import 'package:flutter/material.dart';

import '../data/game_data.dart';
import '../core/save/save_service.dart';
import '../core/world/time_service.dart';

import 'animal_market_screen.dart';
import 'caravan_screen.dart';
import 'cartwright_screen.dart';
import 'debug_screen.dart';
import 'doctor_screen.dart';
import 'industries_screen.dart';
import 'ledger_screen.dart';
import 'market_screen.dart';
import 'npc_caravans_screen.dart';
import 'recruitment_screen.dart';
import 'vehicle_market_screen.dart';
import 'vet_screen.dart';
import 'world_map_screen.dart';

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
    final city =
        game.player.currentCity;

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
              '${city?.name ?? 'Wilderness'}',
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
                            const WorldMapScreen(),
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
                            CaravanScreen(
                          caravan:
                              game.player.caravan,
                        ),
                      ),
                    ).then(
                      (_) => setState(() {}),
                    );
                  },
                  child: const Text(
                    'Caravan',
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            RecruitmentScreen(
                          playerState:
                              game.player,
                        ),
                      ),
                    ).then(
                      (_) => setState(() {}),
                    );
                  },
                  child: const Text(
                    'Recruitment',
                  ),
                ),

                if (city?.animalMarketTier !=
                    null)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AnimalMarketScreen(
                            playerState:
                                game.player,
                            tier: city!
                                .animalMarketTier!,
                          ),
                        ),
                      ).then(
                        (_) =>
                            setState(() {}),
                      );
                    },
                    child: const Text(
                      'Animal Market',
                    ),
                  ),

                if (city?.vehicleMarketTier !=
                    null)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              VehicleMarketScreen(
                            playerState:
                                game.player,
                            tier: city!
                                .vehicleMarketTier!,
                          ),
                        ),
                      ).then(
                        (_) =>
                            setState(() {}),
                      );
                    },
                    child: const Text(
                      'Vehicle Dealer',
                    ),
                  ),

                if (city?.hasVet ?? false)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              VetScreen(
                            playerState:
                                game.player,
                          ),
                        ),
                      ).then(
                        (_) =>
                            setState(() {}),
                      );
                    },
                    child: const Text(
                      'Vet',
                    ),
                  ),

                if (city?.hasCartwright ??
                    false)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              CartwrightScreen(
                            playerState:
                                game.player,
                          ),
                        ),
                      ).then(
                        (_) =>
                            setState(() {}),
                      );
                    },
                    child: const Text(
                      'Cartwright',
                    ),
                  ),

                if (city?.hasDoctor ??
                    false)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const DoctorScreen(),
                        ),
                      ).then(
                        (_) =>
                            setState(() {}),
                      );
                    },
                    child: const Text(
                      'Doctor',
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

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const NpcCaravansScreen(),
                      ),
                    ).then(
                      (_) => setState(() {}),
                    );
                  },
                  child: const Text(
                    'NPC Caravans',
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