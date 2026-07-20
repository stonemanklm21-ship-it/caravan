import '../core/quests/character_registry.dart';
import 'character_data.dart';

final characterRegistry =
    CharacterRegistry({
  defaultPlayer.id: defaultPlayer,
  defaultNpc.id: defaultNpc,
  miningMerchant.id: miningMerchant,
});