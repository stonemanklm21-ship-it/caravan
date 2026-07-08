import '../models/character.dart';

class CharacterHealthService {
  static double healCost(
    Character character,
  ) {
    return (character.maxHp -
            character.hp) *
        10;
  }

  static bool canHeal(
    Character character,
  ) {
    return character.hp <
        character.maxHp;
  }

  static void heal(
    Character character,
  ) {
    character.hp =
        character.maxHp;
  }
}