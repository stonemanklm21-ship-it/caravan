import '../core/models/animal_type.dart';

const donkey = AnimalType(
  id: 'donkey',
  name: 'Donkey',
  maxHp: 100,
  lifeExpectancyYears: 30,
  averageAdultWeightKg: 200,
  speed: 0.8,
  basePrice: 10000,
);

const horse = AnimalType(
  id: 'horse',
  name: 'Horse',
  maxHp: 120,
  lifeExpectancyYears: 25,
  averageAdultWeightKg: 500,
  speed: 1.5,
  basePrice: 25000,
);

const ox = AnimalType(
  id: 'ox',
  name: 'Ox',
  maxHp: 180,
  lifeExpectancyYears: 20,
  averageAdultWeightKg: 800,
  speed: 0.6,
  basePrice: 100000,
);

const camel = AnimalType(
  id: 'camel',
  name: 'Camel',
  maxHp: 150,
  lifeExpectancyYears: 35,
  averageAdultWeightKg: 600,
  speed: 1.2,
  basePrice: 150000,
);

const animalTypes = [
  donkey,
  horse,
  ox,
  camel,
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