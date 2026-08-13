import '../models/animal.dart';
import '../models/armour.dart';
import '../models/cargo_item.dart';
import '../models/helmet.dart';
import '../models/vehicle.dart';
import '../models/weapon.dart';

class SelectedLoot {
  final List<CargoItem> inventory;
  final List<Weapon> weapons;
  final List<Armour> armours;
  final List<Helmet> helmets;
  final List<Animal> animals;
  final List<Vehicle> vehicles;

  const SelectedLoot({
    required this.inventory,
    required this.weapons,
    required this.armours,
    required this.helmets,
    required this.animals,
    required this.vehicles,
  });

  factory SelectedLoot.empty() {
    return const SelectedLoot(
      inventory: [],
      weapons: [],
      armours: [],
      helmets: [],
      animals: [],
      vehicles: [],
    );
  }
}