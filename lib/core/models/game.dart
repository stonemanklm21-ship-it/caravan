import 'player_state.dart';
import 'world.dart';

class Game {
  World world;

  PlayerState player;

  Game({
    required this.world,
    required this.player,
  });

  Map<String, dynamic> toJson() {
    return {
      'player': player.toJson(),
      'world': world.toJson(),
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
    );
  }
}