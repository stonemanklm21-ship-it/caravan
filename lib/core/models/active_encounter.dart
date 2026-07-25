import 'npc_caravan.dart';

class ActiveEncounter {
  final NpcCaravan bandit;
  final NpcCaravan merchant;

  final double banditX;
  final double banditY;

  final double merchantX;
  final double merchantY;

  double hoursRemaining;

  ActiveEncounter({
    required this.bandit,
    required this.merchant,
    required this.banditX,
    required this.banditY,
    required this.merchantX,
    required this.merchantY,
    this.hoursRemaining = 4,
  });
}