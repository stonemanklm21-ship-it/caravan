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
  maxCombatLevel: 10, //re-balance later
  minCompanions: 2,
  maxCompanions: 3,
);

const raiders = BanditFaction(
  id: 'raiders',
  name: 'Raiders',
  preferredWeapon: knife,
  maxCombatLevel: 50,
  minCompanions: 1,
  maxCompanions: 3,
);

const brigands = BanditFaction(
  id: 'brigands',
  name: 'Brigands',
  preferredWeapon: spear,
  maxCombatLevel: 60,
  minCompanions: 2,
  maxCompanions: 4,
);

const outlaws = BanditFaction(
  id: 'outlaws',
  name: 'Outlaws',
  preferredWeapon: sword,
  maxCombatLevel: 70,
  minCompanions: 3,
  maxCompanions: 5,
);

const reavers = BanditFaction(
  id: 'reavers',
  name: 'Reavers',
  preferredWeapon: battleAxe,
  maxCombatLevel: 80,
  minCompanions: 4,
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