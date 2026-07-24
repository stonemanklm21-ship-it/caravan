import '../core/models/bandit_faction.dart';
import '../core/models/region.dart';

import 'weapon_data.dart';

BanditFaction banditFactionForId(
  String id,
) {
  return banditFactions.firstWhere(
    (faction) => faction.id == id,
  );
}

const marauders = BanditFaction(
  id: 'marauders',
  name: 'Marauders',
  preferredWeapon: club,
  maxCombatLevel: 20,
  maxCompanions: 2,
);

const raiders = BanditFaction(
  id: 'raiders',
  name: 'Raiders',
  preferredWeapon: knife,
  maxCombatLevel: 30,
  maxCompanions: 3,
);

const brigands = BanditFaction(
  id: 'brigands',
  name: 'Brigands',
  preferredWeapon: spear,
  maxCombatLevel: 40,
  maxCompanions: 4,
);

const outlaws = BanditFaction(
  id: 'outlaws',
  name: 'Outlaws',
  preferredWeapon: sword,
  maxCombatLevel: 50,
  maxCompanions: 5,
);

const reavers = BanditFaction(
  id: 'reavers',
  name: 'Reavers',
  preferredWeapon: battleAxe,
  maxCombatLevel: 60,
  maxCompanions: 6,
);

const banditFactions = [
  marauders,
  raiders,
  brigands,
  outlaws,
  reavers,
];

BanditFaction banditFactionForRegion(
  Region region,
) {
  switch (region.level) {
    case 1:
      return marauders;
    case 2:
      return raiders;
    case 3:
      return brigands;
    case 4:
      return outlaws;
    default:
      return reavers;
  }
}