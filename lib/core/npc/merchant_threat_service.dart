import 'dart:math';

import 'package:merchantcaravan/core/world/location_service.dart';

import '../../data/game_balance.dart';
import '../combat/combat_strength_service.dart';
import '../models/caravan_faction.dart';
import '../models/npc_caravan.dart';
import '../models/world.dart';
import '../world/visibility_service.dart';
import 'npc_travel_service.dart';

class MerchantThreatService {
  static void handleThreats({
    required NpcCaravan merchant,
    required World world,
    required double worldTimeHours,
    required double tickFraction,
  }) {
    if (merchant.faction !=
        CaravanFaction.merchant) {
      return;
    }

    if (merchant.currentCity != null) {
      return;
    }

    final journey =
        merchant.activeJourney;

    if (journey == null) {
      return;
    }

    final destination =
        journey.destinationCity;

    if (destination == null) {
      return;
    }

    final merchantX =
        NpcTravelService.currentXSmooth(
      npc: merchant,
      worldTimeHours:
          worldTimeHours,
      tickFraction:
          tickFraction,
    );

    final merchantY =
        NpcTravelService.currentYSmooth(
      npc: merchant,
      worldTimeHours:
          worldTimeHours,
      tickFraction:
          tickFraction,
    );

final city =
    LocationService.cityAtPosition(
  world: world,
  x: merchantX,
  y: merchantY,
);

if (city != null) {
  return;
}
    NpcCaravan? nearestBandit;

    double nearestDistance =
        double.infinity;

    for (final npc
        in world.npcCaravans) {
      if (npc.faction !=
          CaravanFaction.bandit) {
        continue;
      }

      if (npc.isInSafeZone) {
        continue;
      }

      final banditX =
          NpcTravelService.currentX(
        npc: npc,
        worldTimeHours:
            worldTimeHours,
      );

      final banditY =
          NpcTravelService.currentY(
        npc: npc,
        worldTimeHours:
            worldTimeHours,
      );

      final distance =
          VisibilityService.distance(
        x1: merchantX,
        y1: merchantY,
        x2: banditX,
        y2: banditY,
      );

      if (distance >
          GameBalance
              .merchantVisionRange) {
        continue;
      }

      if (distance <
          nearestDistance) {
        nearestDistance =
            distance;

        nearestBandit = npc;
      }
    }

if (nearestBandit == null) {
  NpcTravelService.startJourney(
    npc: merchant,
    destination: destination,
    worldTimeHours: worldTimeHours,
    originX: merchantX,
    originY: merchantY,
    departureHour:
        worldTimeHours +
        tickFraction,
  );

  merchant.lastDecision =
      'Travelling to ${destination.name}';

  return;
}

    final ratio =
        CombatStrengthService
            .strengthRatio(
      attacker:
          nearestBandit.caravan,
      defender: merchant.caravan,
    );

if (ratio <
    GameBalance
        .merchantFleeRatio) {

  NpcTravelService.startJourney(
    npc: merchant,
    destination: destination,
    worldTimeHours:
        worldTimeHours,
    originX: merchantX,
    originY: merchantY,
    departureHour:
        worldTimeHours +
        tickFraction,
  );

  return;
}

    final banditX =
        NpcTravelService.currentX(
      npc: nearestBandit,
      worldTimeHours:
          worldTimeHours,
    );

    final banditY =
        NpcTravelService.currentY(
      npc: nearestBandit,
      worldTimeHours:
          worldTimeHours,
    );

    double steerX =
        destination.x - merchantX;

    double steerY =
        destination.y - merchantY;

    final avoidX =
        merchantX - banditX;

    final avoidY =
        merchantY - banditY;

    steerX += avoidX * 2.0;
    steerY += avoidY * 2.0;

    final length = sqrt(
      steerX * steerX +
          steerY * steerY,
    );

    if (length < 0.001) {
      return;
    }

    steerX /= length;
    steerY /= length;

const steeringDistance =
    100.0;

final targetX =
    merchantX +
    steerX *
        steeringDistance;

final targetY =
    merchantY +
    steerY *
        steeringDistance;

    NpcTravelService
        .startJourneyToCoordinates(
      npc: merchant,
      destinationX: targetX,
      destinationY: targetY,
      destinationCity:
          destination,
      worldTimeHours:
          worldTimeHours,
      originX: merchantX,
      originY: merchantY,
      departureHour:
          worldTimeHours +
          tickFraction,
    );

    merchant.lastDecision =
        'Avoiding bandit';
  }
}