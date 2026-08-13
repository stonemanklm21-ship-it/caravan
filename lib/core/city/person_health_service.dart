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

  static double healAllCost(
    Iterable<Character> characters,
  ) {
    return characters.fold(
      0,
      (total, character) =>
          total + healCost(character),
    );
  }

  static bool canHealAny(
    Iterable<Character> characters,
  ) {
    return characters.any(
      canHeal,
    );
  }

  static void heal(
    Character character,
  ) {
    character.hp =
        character.maxHp;
  }

  static void healAll(
    Iterable<Character> characters,
  ) {
    for (final character
        in characters) {
      heal(character);
    }
  }
}