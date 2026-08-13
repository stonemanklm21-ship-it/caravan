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

  static double healAllCost(
    Iterable<Animal> animals,
  ) {
    return animals.fold(
      0,
      (total, animal) =>
          total + healCost(animal),
    );
  }

  static bool canHealAny(
    Iterable<Animal> animals,
  ) {
    return animals.any(
      canHeal,
    );
  }

  static void heal(
    Animal animal,
  ) {
    animal.hp =
        animal.type.maxHp;
  }

  static void healAll(
    Iterable<Animal> animals,
  ) {
    for (final animal
        in animals) {
      heal(animal);
    }
  }
}