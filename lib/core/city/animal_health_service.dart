import '../models/animal.dart';

class AnimalHealthService {
  static double healCost(
    Animal animal,
  ) {
    return (animal.type.maxHp -
            animal.hp) *
        10;
  }

  static bool canHeal(
    Animal animal,
  ) {
    return animal.hp <
        animal.type.maxHp;
  }

  static void heal(
    Animal animal,
  ) {
    animal.hp =
        animal.type.maxHp;
  }
}