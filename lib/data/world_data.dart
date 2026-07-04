import '../core/models/world.dart';
import '../core/npc/npc_caravan_generator.dart';
import 'cities_data.dart';

final world = World(
  cities: cities,
npcCaravans:
    NpcCaravanGenerator.generate(
  cities: cities,
),
);