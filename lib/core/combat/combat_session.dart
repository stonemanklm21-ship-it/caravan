import '../models/caravan.dart';

import 'combat_encounter.dart';
import 'combat_loot.dart';
import 'combat_result.dart';

class CombatSession {
  final CombatEncounter encounter;

  final List<String> playerCombatantsAtStart;
  final List<String> enemyCombatantsAtStart;

  CombatSession({
    required this.encounter,
    required this.playerCombatantsAtStart,
    required this.enemyCombatantsAtStart,
  });

  factory CombatSession.fromEncounter(
    CombatEncounter encounter,
  ) {
    return CombatSession(
      encounter: encounter,
      playerCombatantsAtStart: [
        encounter.defenders.leader.name,
        ...encounter.defenders.companions.map(
          (c) => c.name,
        ),
      ],
      enemyCombatantsAtStart: [
        encounter.attackers.leader.name,
        ...encounter.attackers.companions.map(
          (c) => c.name,
        ),
      ],
    );
  }

List<String> playerDeaths() {
  final survivors = [
    encounter.defenders.leader,
    ...encounter.defenders.companions,
  ]
      .where((c) => c.alive)
      .map((c) => c.name)
      .toList();

  return playerCombatantsAtStart
      .where(
        (name) => !survivors.contains(name),
      )
      .toList();
}

List<String> enemyDeaths() {
  final survivors = [
    encounter.attackers.leader,
    ...encounter.attackers.companions,
  ]
      .where((c) => c.alive)
      .map((c) => c.name)
      .toList();

  return enemyCombatantsAtStart
      .where(
        (name) => !survivors.contains(name),
      )
      .toList();
}

  CombatResult buildResult({
    required bool victory,
    required Caravan defeatedCaravan,
  }) {
    double goldLooted = 0;

    if (victory) {
      goldLooted = defeatedCaravan.gold;

      encounter.defenders.gold +=
          defeatedCaravan.gold;

      defeatedCaravan.gold = 0;
    }

    return CombatResult(
      victory: victory,
      playerDeaths: playerDeaths(),
      enemyDeaths: enemyDeaths(),
    loot: CombatLoot(
  gold: goldLooted,

  inventory: List.from(
    defeatedCaravan.inventory,
  ),

  weapons: [
    ...defeatedCaravan.weapons,
    if (defeatedCaravan.leader.weapon != null)
      defeatedCaravan.leader.weapon!,
    ...defeatedCaravan.companions
        .where((c) => c.weapon != null)
        .map((c) => c.weapon!),
  ],

  armours: [
    ...defeatedCaravan.armours,
    if (defeatedCaravan.leader.armour != null)
      defeatedCaravan.leader.armour!,
    ...defeatedCaravan.companions
        .where((c) => c.armour != null)
        .map((c) => c.armour!),
  ],

  helmets: [
    ...defeatedCaravan.helmets,
    if (defeatedCaravan.leader.helmet != null)
      defeatedCaravan.leader.helmet!,
    ...defeatedCaravan.companions
        .where((c) => c.helmet != null)
        .map((c) => c.helmet!),
  ],

  animals: List.from(
    defeatedCaravan.animals,
  ),

  vehicles: List.from(
    defeatedCaravan.vehicles,
  ),
),
      defeatedCaravan: defeatedCaravan,
    );
  }
}