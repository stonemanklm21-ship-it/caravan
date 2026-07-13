import '../models/character.dart';

enum CombatResultType {
  miss,
  block,
  hit,
}

class CombatRoundResult {
  final Character attacker;

  final Character defender;

  final CombatResultType result;

  final int damage;

  CombatRoundResult({
    required this.attacker,
    required this.defender,
    required this.result,
    required this.damage,
  });

  @override
  String toString() {
    switch (result) {
      case CombatResultType.miss:
        return '${attacker.name} attacks '
            '${defender.name} and misses.';

      case CombatResultType.block:
        return '${attacker.name} attacks '
            '${defender.name} but the attack is blocked.';

      case CombatResultType.hit:
        return '${attacker.name} attacks '
            '${defender.name} for '
            '$damage damage.';
    }
  }
}