import 'package:cargo_quest_tycoon/game/bloc/game_bloc.dart';
import 'package:cargo_quest_tycoon/game/transport_game.dart';
import 'package:cargo_quest_tycoon/game/transport_world.dart';
import 'package:cargo_quest_tycoon/game/widgets/game_stats_bar.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CargoQuestGame extends StatelessWidget {
  const CargoQuestGame({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameBloc(),
      child: const GameView(),
    );
  }
}

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget.controlled(
            gameFactory: () {
              final myWorld = TransportWorld();
              return TransportGame(
                gameBloc: context.read<GameBloc>(),
                world: myWorld,
                camera: CameraComponent(
                  world: myWorld,
                  viewport: MaxViewport(),
                  // viewfinder: Viewfinder()..anchor = Anchor.topLeft,
                ),
              );
            },
          ),
          const GameStatsBar(),
        ],
      ),
    );
  }
}
