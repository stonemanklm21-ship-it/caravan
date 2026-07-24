import '../models/caravan.dart';
import '../models/vehicle.dart';
import 'animal_service.dart';
import '../models/skill.dart';
import 'skill_service.dart';

class VehicleService {
  static void advanceTime({
    required Caravan caravan,
    required Vehicle vehicle,
    required double hours,
  }) {

    const unmitigatedDailyLoss = 5.0;

    final mitigatedDailyLoss =
        SkillService.asymptoticValue(
      skill:
          caravan.mechanicSkill.toDouble(),
      start: 5.0,
      end: 1.0,
    );

    final unmitigatedLoss =
        (hours / 24) *
        unmitigatedDailyLoss;

    final actualLoss =
        (hours / 24) *
        mitigatedDailyLoss;

    final preventedLoss =
        unmitigatedLoss - actualLoss;

    vehicle.condition -= actualLoss;

    if (vehicle.condition < 0) {
      vehicle.condition = 0;
    }

    SkillService.addSharedXp(
      characters: [
        caravan.leader,
        ...caravan.companions,
      ],
      skill: Skill.mechanic,
      amount:
          preventedLoss * 10,
    );
  }

  static void advanceTimeForAll({
    required Caravan caravan,
    required List<Vehicle> vehicles,
    required double hours,
  }) {
    for (final vehicle in vehicles) {
      advanceTime(
        caravan: caravan,
        vehicle: vehicle,
        hours: hours,
      );
    }
  }

  static void repair({
    required Vehicle vehicle,
    required double amount,
  }) {
    vehicle.condition += amount;

    if (vehicle.condition >
        vehicle.type.maxCondition) {
      vehicle.condition =
          vehicle.type.maxCondition;
    }
  }

  static bool operational(
    Vehicle vehicle,
  ) {
    return vehicle.condition > 0;
  }

  static bool canPull(
    Vehicle vehicle,
  ) {
    final animal =
        vehicle.draftAnimal;

    if (animal == null) {
      return false;
    }

    return AnimalService
            .cargoCapacityKg(
          animal,
        ) >=
        vehicle.type
            .requiredPullingCapacityKg;
  }

  static double conditionFraction(
    Vehicle vehicle,
  ) {
    return vehicle.condition /
        vehicle.type.maxCondition;
  }

  static double effectiveCapacityMultiplier(
    Vehicle vehicle,
  ) {
    return vehicle.type
            .capacityMultiplier *
        conditionFraction(vehicle);
  }

  static double effectiveMaxCargoKg(
    Vehicle vehicle,
  ) {
    return vehicle.type.maxCargoKg *
        conditionFraction(vehicle);
  }

  static double cargoCapacityKg(
    Vehicle vehicle,
  ) {
    if (!operational(vehicle) ||
        !canPull(vehicle)) {
      return 0;
    }

    final pullingCapacity =
        AnimalService
            .cargoCapacityKg(
          vehicle.draftAnimal!,
        );

    final capacity =
        pullingCapacity *
        effectiveCapacityMultiplier(
          vehicle,
        );

    final maxCapacity =
        effectiveMaxCargoKg(
          vehicle,
        );

    return capacity < maxCapacity
        ? capacity
        : maxCapacity;
  }
}