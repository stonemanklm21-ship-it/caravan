import '../models/caravan.dart';

import 'combat_loot.dart';

class CombatResult {
  final bool victory;

  final List<String> playerDeaths;
  final List<String> enemyDeaths;

  final CombatLoot loot;

  final Caravan defeatedCaravan;

  CombatResult({
    required this.victory,
    required this.playerDeaths,
    required this.enemyDeaths,
    required this.loot,
    required this.defeatedCaravan,
  });
}