import 'package:flutter/material.dart';

import '../core/combat/combat_result.dart';
import '../core/combat/combat_session.dart';
import '../core/combat/combat_service.dart';
import '../core/combat/combat_round_result.dart';
import '../core/combat/combat_strength_service.dart';
import '../screens/combat_result_screen.dart';

class CombatScreen extends StatefulWidget {
  final CombatSession session;

  const CombatScreen({
    super.key,
    required this.session,
  });

  @override
  State<CombatScreen> createState() =>
      _CombatScreenState();
}

class _CombatScreenState
    extends State<CombatScreen> {
  final List<String> log = [];

  int roundNumber = 0;
  bool rewardsGranted = false;

  bool get playerDefeated =>
      CombatService.combatants(
        widget.session.encounter.defenders,
      ).isEmpty;

  bool get enemyDefeated =>
      CombatService.combatants(
        widget.session.encounter.attackers,
      ).isEmpty;

  bool get combatEnded =>
      playerDefeated ||
      enemyDefeated;

  void _runRound() {
    if (combatEnded) {
      return;
    }

    roundNumber++;

    final results =
        <CombatRoundResult>[];

    results.addAll(
      CombatService.resolveRound(
        attackers:
            CombatService.combatants(
          widget.session.encounter.defenders,
        ),
        defenders:
            CombatService.combatants(
          widget.session.encounter.attackers,
        ),
      ),
    );

    results.addAll(
      CombatService.resolveRound(
        attackers:
            CombatService.combatants(
          widget.session.encounter.attackers,
        ),
        defenders:
            CombatService.combatants(
          widget.session.encounter.defenders,
        ),
      ),
    );

    setState(() {
      log.add(
        '--- Round $roundNumber ---',
      );

      for (final result
          in results) {
        log.add(
          result.toString(),
        );
      }

      if (enemyDefeated &&
          !rewardsGranted) {
        rewardsGranted = true;
      }
    });
  }

  Widget _buildSide({
    required String title,
    required List combatants,
  }) {
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style:
                  const TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            ...combatants.map(
              (character) => Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    '${character.name}: '
                    '${character.hp.toStringAsFixed(0)} HP',
                  ),
                  Text(
                    '  Weapon: ${character.weapon?.name ?? "None"}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '  Armour: ${character.armour?.name ?? "None"}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '  Helmet: ${character.helmet?.name ?? "None"}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                ],
              ),
            ),
            if (combatants.isEmpty)
              const Text(
                'No survivors',
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final playerSide =
        CombatService.combatants(
      widget.session.encounter
          .defenders,
    );

    final enemySide =
        CombatService.combatants(
      widget.session.encounter
          .attackers,
    );

    final playerStrength =
        CombatStrengthService
            .caravanStrength(
      widget.session.encounter
          .defenders,
    );

    final enemyStrength =
        CombatStrengthService
            .caravanStrength(
      widget.session.encounter
          .attackers,
    );

    final strengthRatio =
        enemyStrength <= 0
            ? 0
            : playerStrength /
                enemyStrength;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Combat',
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.all(8),
            child: Column(
              children: [
                Text(
                  'Player Strength: '
                  '${playerStrength.toStringAsFixed(1)}',
                ),
                Text(
                  'Enemy Strength: '
                  '${enemyStrength.toStringAsFixed(1)}',
                ),
                Text(
                  'Strength Ratio: '
                  '${strengthRatio.toStringAsFixed(2)}',
                ),
              ],
            ),
          ),

          _buildSide(
            title: 'Player Caravan',
            combatants: playerSide,
          ),

          _buildSide(
            title: 'Enemy Caravan',
            combatants: enemySide,
          ),

          Padding(
            padding:
                const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed:
                  combatEnded
                      ? null
                      : _runRound,
              child: const Text(
                'Run Round',
              ),
            ),
          ),

          if (combatEnded)
            Padding(
              padding:
                  const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () async {
                  final result =
                      widget.session.buildResult(
                    victory:
                        enemyDefeated,
                    defeatedCaravan:
                        enemyDefeated
                            ? widget
                                  .session
                                  .encounter
                                  .attackers
                            : widget
                                  .session
                                  .encounter
                                  .defenders,
                  );

                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          CombatResultScreen(
                        result: result,
                        caravan: widget
                            .session
                            .encounter
                            .defenders,
                      ),
                    ),
                  );

                  if (!context.mounted) {
                    return;
                  }

                  Navigator.pop<
                      CombatResult>(
                    context,
                    result,
                  );
                },
                child: const Text(
                  'Continue',
                ),
              ),
            ),

          const Divider(),

          Expanded(
            child: ListView.builder(
              itemCount:
                  log.length,
              itemBuilder:
                  (
                    context,
                    index,
                  ) {
                return ListTile(
                  dense: true,
                  title: Text(
                    log[index],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}