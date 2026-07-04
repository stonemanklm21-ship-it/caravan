import '../core/models/animal_type.dart';

const donkey = AnimalType(
  id: 'donkey',
  name: 'Donkey',
  maxHp: 100,
);

const horse = AnimalType(
  id: 'horse',
  name: 'Horse',
  maxHp: 120,
);

const animalTypes = [
  donkey,
  horse,
];

final animalTypesById = {
  for (final animal in animalTypes)
    animal.id: animal,
};

AnimalType animalTypeForId(
  String id,
) {
  return animalTypesById[id]!;
}
