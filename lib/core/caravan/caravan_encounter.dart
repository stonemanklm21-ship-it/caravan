import '../models/caravan_faction.dart';
import '../models/npc_caravan.dart';
import 'encounter_action.dart';

class CaravanEncounter {
  final NpcCaravan npc;

  const CaravanEncounter({
    required this.npc,
  });

  bool get isMerchant =>
      npc.faction == CaravanFaction.merchant;

  bool get isBandit =>
      npc.faction == CaravanFaction.bandit;

  String get title {
    if (isMerchant) {
      return 'Merchant Caravan';
    }

    if (isBandit) {
      return 'Bandit Caravan';
    }

    return 'Caravan';
  }

  List<EncounterAction> get actions {
    if (isMerchant) {
      return [
        EncounterAction.trade,
        EncounterAction.attack,
        EncounterAction.ignore,
      ];
    }

    if (isBandit) {
      return [
        EncounterAction.fight,
        EncounterAction.payTribute,
      ];
    }

    return [
      EncounterAction.ignore,
    ];
  }
}