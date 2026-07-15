import 'package:flutter/material.dart';

import '../core/combat/combat_encounter.dart';
import '../core/combat/combat_round_result.dart';
import '../core/combat/combat_service.dart';

class CombatScreen extends StatefulWidget {
  final CombatEncounter encounter;

  const CombatScreen({
    super.key,
    required this.encounter,
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
        widget.encounter.defenders,
      ).isEmpty;

  bool get enemyDefeated =>
      CombatService.combatants(
        widget.encounter.attackers,
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
          widget.encounter.defenders,
        ),
        defenders:
            CombatService.combatants(
          widget.encounter.attackers,
        ),
      ),
    );

    results.addAll(
      CombatService.resolveRound(
        attackers:
            CombatService.combatants(
          widget.encounter.attackers,
        ),
        defenders:
            CombatService.combatants(
          widget.encounter.defenders,
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

if (enemyDefeated && !rewardsGranted) {
  
rewardsGranted = true;

  final goldWon =
      widget.encounter.attackers.gold;

  widget.encounter.defenders.gold +=
      goldWon;

  widget.encounter.attackers.gold = 0;

  log.add(
    'Victory!',
  );

  log.add(
    'Looted ${goldWon.toStringAsFixed(0)} gold.',
  );
}

      if (playerDefeated) {
        log.add(
          'Defeat!',
        );
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
              (character) =>
                  Text(
                '${character.name}: '
                '${character.hp.toStringAsFixed(0)} HP',
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
      widget.encounter.defenders,
    );

    final enemySide =
        CombatService.combatants(
      widget.encounter.attackers,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Combat',
        ),
      ),
      body: Column(
        children: [
          if (enemyDefeated)
            const Padding(
              padding:
                  EdgeInsets.all(8),
              child: Text(
                'VICTORY',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight:
                      FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),

          if (playerDefeated)
            const Padding(
              padding:
                  EdgeInsets.all(8),
              child: Text(
                'DEFEAT',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight:
                      FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),

          _buildSide(
            title: 'Player Caravan',
            combatants:
                playerSide,
          ),

          _buildSide(
            title: 'Enemy Caravan',
            combatants:
                enemySide,
          ),

          Padding(
            padding:
                const EdgeInsets.all(
              8,
            ),
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
                  const EdgeInsets.all(
                8,
              ),
              child: ElevatedButton(
  onPressed: () {
    Navigator.pop(
      context,
      enemyDefeated,
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