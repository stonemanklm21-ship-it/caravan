import 'package:flutter/material.dart';

import '../../data/game_data.dart';
import '../../screens/npc_trade_screen.dart';
import '../world/map_encounter_interaction_service.dart';

import 'caravan_encounter.dart';
import 'caravan_encounter_dialog.dart';
import 'encounter_action.dart';

import '../../screens/combat_screen.dart';
import '../combat/combat_encounter.dart';
import '../models/caravan_faction.dart';
import '../combat/combat_session.dart';
import '../combat/combat_result.dart';

class CaravanEncounterHandler {
  static Future<void> handle(
    BuildContext context,
    CaravanEncounter encounter,
  ) async {
    final action =
        await CaravanEncounterDialog.show(
      context,
      encounter,
    );
if (!context.mounted) {
  return;
}
    if (action == null) {
      return;
    }

    switch (action) {
      case EncounterAction.trade:
        MapEncounterInteractionService
            .dismissEncounter(
          player: game.player,
        );

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NpcTradeScreen(
              npc: encounter.npc,
            ),
          ),
        );
        break;

      case EncounterAction.ignore:
        MapEncounterInteractionService
            .ignoreEncounter(
          player: game.player,
          npc: encounter.npc,
        );
        break;

case EncounterAction.attack:
  MapEncounterInteractionService
      .dismissEncounter(
    player: game.player,
  );

  await Navigator.push<bool>(
    context,
    MaterialPageRoute(
      builder: (_) => CombatScreen(
        session: CombatSession.fromEncounter(
          CombatEncounter(
          attackers: game.player.caravan,
          defenders: encounter.npc.caravan,
          attackerFaction:
              CaravanFaction.merchant,
          defenderFaction:
              encounter.npc.faction,
        ),
      ),
      ),
    ),
  );

  break;

case EncounterAction.fight:
  MapEncounterInteractionService
      .dismissEncounter(
    player: game.player,
  );

final result =
    await Navigator.push<CombatResult>(
  context,
  MaterialPageRoute(
    builder: (_) => CombatScreen(
      session: CombatSession.fromEncounter(
        CombatEncounter(
          attackers: encounter.npc.caravan,
          defenders: game.player.caravan,
          attackerFaction:
              encounter.npc.faction,
          defenderFaction:
              CaravanFaction.merchant,
        ),
      ),
    ),
  ),
);

if (!context.mounted ||
    result == null) {
  break;
}

  break;

case EncounterAction.payTribute:
  final tribute =
      game.player.caravan.gold * 0.2;

  game.player.caravan.gold -= tribute;

  encounter.npc.caravan.gold += tribute;

  game.player.banditProtectionHours =
      24;
      
MapEncounterInteractionService
    .ignoreEncounter(
  player: game.player,
  npc: encounter.npc,
);

  break;
    }
  }
}