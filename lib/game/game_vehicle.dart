import 'dart:async';
import 'dart:ui' as ui;
import 'package:cargo_quest_tycoon/game/bloc/game_bloc.dart';
import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import 'package:cargo_quest_tycoon/core/constants/game_constants.dart';
import 'package:cargo_quest_tycoon/data/enums/map_tile_type.dart';
import 'package:cargo_quest_tycoon/game/game_tile.dart';
import 'package:cargo_quest_tycoon/game/path_finder.dart';
import 'package:cargo_quest_tycoon/game/transport_game.dart';
import 'package:cargo_quest_tycoon/game/transport_world.dart';
import 'package:flame/components.dart';

class GameVehicle extends PositionComponent
    with
        HasWorldReference<TransportWorld>,
        TapCallbacks,
        HoverCallbacks,
        GestureHitboxes {
  final Vector2 velocity = Vector2.zero();
  final List<Vector2> path = [];
  String? pathId;
  int currentPathIndex = 0;
  bool isMoving = false;
  double speed = 100.0;
  late final RectangleHitbox hitbox;
  final baseColor = Colors.black;
  final hoverColor = Colors.teal;

  GameVehicle({
    required Vector2 position,
  }) : super(position: position, size: Vector2(32, 32));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    hitbox =
        RectangleHitbox(size: Vector2(32, 32), position: Vector2(-16, -16));
    hitbox.paint.color = baseColor;
    hitbox.renderShape = true;
    add(hitbox);
  }

  static final _temporaryPoint = Vector2.zero();

  // @override
  // bool containsLocalPoint(Vector2 point) {
  //   final isTrue = hitboxes.any(
  //     (hitbox) => hitbox.containsLocalPoint(
  //       hitbox.parentToLocal(point, output: _temporaryPoint),
  //     ),
  //   );
  //   print('Vehicle contains point: $isTrue');
  //   return isTrue;
  // }

  @override
  void onHoverEnter() {
    hitbox.paint.color = hoverColor;
    super.onHoverEnter();
  }

  @override
  void onHoverExit() {
    hitbox.paint.color = baseColor;
    super.onHoverExit();
  }

  @override
  void onTapDown(TapDownEvent event) {
    print('Tapped vehicle');
    generateNewRoute();
    super.onTapDown(event);
  }

  void generateNewRoute() {
    final (path, pathId) = world.generatePath(position);
    setDestination(path, pathId);
  }

  void setDestination(List<Vector2> path, String id) {
    pathId = id;
    if (path.isNotEmpty) {
      this.path.clear();
      this.path.addAll(path);
      currentPathIndex = 0;
      position.setValues(path.first.x, path.first.y);
      isMoving = true;
    }
  }

  @override
  void update(double dt) {
    if (isMoving && path.isNotEmpty) {
      final nextPosition = path[currentPathIndex];
      final direction = (nextPosition - position).normalized();
      velocity.setValues(direction.x, direction.y);
      position.add(velocity * speed * dt);

      if (position.distanceTo(nextPosition) < 1) {
        currentPathIndex++;
        if (currentPathIndex >= path.length) {
          isMoving = false;
          if (pathId != null) world.removePath(pathId!);
          final coins = path.length;
          world.game.gameBloc.add(GameGainCoins(coins));
          world.game.showAlert('Truck delivered $coins coins');
          generateNewRoute();
        }
      }
    }
  }

  @override
  void render(ui.Canvas canvas) {
    if (isMoving) {
      canvas.drawCircle(
          Offset.zero, 16, ui.Paint()..color = ui.Color(0xFF00FF00));
      ui.ParagraphBuilder builder = ui.ParagraphBuilder(ui.ParagraphStyle(
        textAlign: TextAlign.center,
        fontSize: 10,
      ))
        ..pushStyle(ui.TextStyle(
            color: Colors.white,
            background: ui.Paint()..color = ui.Color(0xFF000000)))
        ..addText('(X: ${position.x.toInt()}, Y: ${position.y.toInt()})');

      final paragraph = builder.build()
        ..layout(ui.ParagraphConstraints(width: size.x * 3));

      canvas.drawParagraph(paragraph, Offset.zero);
    } else {
      canvas.drawCircle(Offset.zero, 16, Paint()..color = Color(0xFFFF0000));
    }

    // if (path.isNotEmpty) {
    //   for (var i = 0; i < path.length - 1; i++) {
    //     final start = path[i].toOffset();
    //     final end = path[i + 1].toOffset();
    //     canvas.drawLine(
    //         start,
    //         end,
    //         Paint()
    //           ..color = Color(0xFF0000FF)
    //           ..strokeWidth = 20);
    //   }
    // }

    super.render(canvas);
  }
}
