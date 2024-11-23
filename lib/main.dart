import 'dart:math';
import 'dart:ui' as ui;

import 'package:cargo_quest_tycoon/core/constants/game_constants.dart';
import 'package:cargo_quest_tycoon/core/constants/predefined_cities.dart';
import 'package:cargo_quest_tycoon/data/models/city.dart';
import 'package:cargo_quest_tycoon/game/transport_game.dart';
import 'package:cargo_quest_tycoon/game/transport_world.dart';
import 'package:cargo_quest_tycoon/widgets/two_dimensional_grid_view.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final myWorld = TransportWorld();
    final myGame = TransportGame(
      world: myWorld,
      camera: CameraComponent(
        world: myWorld,
        viewport: MaxViewport(),
        viewfinder: Viewfinder()..anchor = Anchor.topLeft,
      ),
    );
    return MaterialApp(
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
        GlobalMaterialLocalizations.delegate,
      ],
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: ui.PointerDeviceKind.values.toSet(),
      ),
      home: GameWidget(game: myGame),
    );
  }
}
