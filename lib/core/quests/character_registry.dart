import '../models/character.dart';

class CharacterRegistry {
  final Map<String, Character>
      _characters;

  CharacterRegistry(
    this._characters,
  );

  Character? get(String id) {
    return _characters[id];
  }

  Iterable<Character>
  get characters =>
      _characters.values;

  List<Character> inCity(
    String cityId,
  ) {
    return _characters.values
        .where(
          (character) =>
              character.cityId ==
              cityId,
        )
        .toList();
  }
}