import 'weapon.dart';

class BanditFaction {
  final String id;
  final String name;
  final Weapon preferredWeapon;

  final int maxCombatLevel;
  final int maxCompanions;

  const BanditFaction({
    required this.id,
    required this.name,
    required this.preferredWeapon,
    required this.maxCombatLevel,
    required this.maxCompanions,
  });
}