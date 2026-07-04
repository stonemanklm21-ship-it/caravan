enum CitySpecialisation {
  farming,
  mining,
  forestry,
}

CitySpecialisation citySpecialisationForName(
  String name,
) {
  return CitySpecialisation.values.firstWhere(
    (specialisation) =>
        specialisation.name == name,
  );
}