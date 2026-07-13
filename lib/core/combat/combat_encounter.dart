import '../models/caravan.dart';
import '../models/caravan_faction.dart';

class CombatEncounter {
  final Caravan attackers;

  final Caravan defenders;

  final CaravanFaction attackerFaction;

  final CaravanFaction defenderFaction;

  CombatEncounter({
    required this.attackers,
    required this.defenders,
    required this.attackerFaction,
    required this.defenderFaction,
  });
}