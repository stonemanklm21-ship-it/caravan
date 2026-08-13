import '../combat/combat_loot.dart';
import '../models/caravan.dart';
import 'selected_loot.dart';

class LootService {
  static void takeAll({
    required Caravan caravan,
    required CombatLoot loot,
  }) {
    caravan.inventory.addAll(
      loot.inventory,
    );

    caravan.weapons.addAll(
      loot.weapons,
    );

    caravan.armours.addAll(
      loot.armours,
    );

    caravan.helmets.addAll(
      loot.helmets,
    );

    caravan.animals.addAll(
      loot.animals,
    );

    caravan.vehicles.addAll(
      loot.vehicles,
    );
  }

  static void takeSelected({
    required Caravan caravan,
    required SelectedLoot loot,
  }) {
    caravan.inventory.addAll(
      loot.inventory,
    );

    caravan.weapons.addAll(
      loot.weapons,
    );

    caravan.armours.addAll(
      loot.armours,
    );

    caravan.helmets.addAll(
      loot.helmets,
    );

    caravan.animals.addAll(
      loot.animals,
    );

    caravan.vehicles.addAll(
      loot.vehicles,
    );
  }
}
