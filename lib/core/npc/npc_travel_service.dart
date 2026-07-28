import '../models/caravan_faction.dart';
import '../models/city.dart';
import '../models/npc_caravan.dart';
import '../travel/journey_factory.dart';
import '../travel/travel_interpolator.dart';

class NpcTravelService {
  static void startJourney({
    required NpcCaravan npc,
    required City destination,
    required double worldTimeHours,
    double? originX,
    double? originY,
    double? departureHour,
  }) {
final startX =
    originX ??
    currentX(
      npc: npc,
      worldTimeHours:
          worldTimeHours,
    );

final startY =
    originY ??
    currentY(
      npc: npc,
      worldTimeHours:
          worldTimeHours,
    );

    final startHour =
        departureHour ??
        worldTimeHours;

    double speed =
        npc.caravan.speed;

    if (npc.faction ==
        CaravanFaction.bandit) {
      speed *= 0.95;
    }

    npc.activeJourney =
        JourneyFactory.create(
      originX: startX,
      originY: startY,
      destinationX: destination.x,
      destinationY: destination.y,
      destinationCity: destination,
      speed: speed,
      departureHour: startHour,
    );

    npc.currentCity = null;
  }

  static void startJourneyToCoordinates({
    required NpcCaravan npc,
    required double destinationX,
    required double destinationY,
    required double worldTimeHours,
    City? destinationCity,
    double? originX,
    double? originY,
    double? departureHour,
  }) {
final startX =
    originX ??
    currentX(
      npc: npc,
      worldTimeHours:
          worldTimeHours,
    );

final startY =
    originY ??
    currentY(
      npc: npc,
      worldTimeHours:
          worldTimeHours,
    );

    final startHour =
        departureHour ??
        worldTimeHours;

    double speed =
        npc.caravan.speed;

    if (npc.faction ==
        CaravanFaction.bandit) {
      speed *= 0.8;
    }

    npc.activeJourney =
        JourneyFactory.create(
      originX: startX,
      originY: startY,
      destinationX: destinationX,
      destinationY: destinationY,
      destinationCity: destinationCity,
      speed: speed,
      departureHour: startHour,
    );

    npc.currentCity = null;
  }

  static void arrive({
    required NpcCaravan npc,
  }) {
    final journey =
        npc.activeJourney;

    if (journey == null) {
      return;
    }

    npc.worldX =
        journey.destinationX;

    npc.worldY =
        journey.destinationY;

    npc.currentCity =
        journey.destinationCity;

    npc.activeJourney = null;
  }

  static double currentX({
    required NpcCaravan npc,
    required double worldTimeHours,
  }) {
    final journey =
        npc.activeJourney;

    if (journey == null) {
      return npc.worldX;
    }

    return TravelInterpolator.x(
      journey,
      worldTimeHours,
    );
  }

  static double currentY({
    required NpcCaravan npc,
    required double worldTimeHours,
  }) {
    final journey =
        npc.activeJourney;

    if (journey == null) {
      return npc.worldY;
    }

    return TravelInterpolator.y(
      journey,
      worldTimeHours,
    );
  }

  static double currentXSmooth({
    required NpcCaravan npc,
    required double worldTimeHours,
    required double tickFraction,
  }) {
    final journey =
        npc.activeJourney;

    if (journey == null) {
      return npc.worldX;
    }

    return TravelInterpolator.x(
      journey,
      worldTimeHours +
          tickFraction,
    );
  }

  static double currentYSmooth({
    required NpcCaravan npc,
    required double worldTimeHours,
    required double tickFraction,
  }) {
    final journey =
        npc.activeJourney;

    if (journey == null) {
      return npc.worldY;
    }

    return TravelInterpolator.y(
      journey,
      worldTimeHours +
          tickFraction,
    );
  }

  static bool hasActiveJourney(
    NpcCaravan npc,
  ) {
    return npc.activeJourney !=
        null;
  }

  static bool isComplete({
    required NpcCaravan npc,
    required double worldTimeHours,
  }) {
    final journey =
        npc.activeJourney;

    if (journey == null) {
      return false;
    }

    return journey.completedAt(
      worldTimeHours,
    );
  }
}