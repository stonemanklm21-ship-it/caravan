import '../core/models/world.dart';
import '../core/npc/npc_caravan_generator.dart';
import '../core/bandits/bandit_caravan_generator.dart';

import 'cities_data.dart';

final merchants =
    NpcCaravanGenerator.generate(
  cities: cities,
);

final bandits =
    BanditCaravanGenerator.generate(
  cities: cities,
  merchantCount:
      merchants.length,
);

final world = World(
  cities: cities,
  npcCaravans: [
    ...merchants,
    ...bandits,
  ],
);

