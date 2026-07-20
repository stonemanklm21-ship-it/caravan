import 'player_state.dart';
import 'world.dart';
import '../quests/quest_state.dart';

class Game {
  World world;

  PlayerState player;

  QuestState quests;

  Game({
    required this.world,
    required this.player,
    required this.quests,
  });

  Map<String, dynamic> toJson() {
    return {
      'player': player.toJson(),
      'world': world.toJson(),
      'quests': quests.toJson(),
    };
  }

  factory Game.fromJson(
    Map<String, dynamic> json,
  ) {
    final world = World.fromJson(
      json['world']
          as Map<String, dynamic>,
    );

    return Game(
      world: world,
      player: PlayerState.fromJson(
        json['player']
            as Map<String, dynamic>,
        world,
      ),
      quests: QuestState.fromJson(
        json['quests']
            as Map<String, dynamic>,
      ),
    );
  }
}
