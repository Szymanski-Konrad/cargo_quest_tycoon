import 'dart:async';
import 'dart:ui' as ui;
import 'package:cargo_quest_tycoon/game/bloc/game_bloc.dart';
import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import 'package:cargo_quest_tycoon/game/transport_world.dart';
import 'package:flame/components.dart';

class GameVehicle extends PositionComponent
    with HasWorldReference<TransportWorld>, TapCallbacks, GestureHitboxes {
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
    add(hitbox);
  }

  @override
  void onTapUp(TapUpEvent event) {
    print('Tapped on vehicle');
    generateNewRoute();
    super.onTapUp(event);
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
          final coins = path.length * 3;
          world.game.gameBloc.add(GameGainCoins(coins));
          world.game.showAlert('Truck delivered $coins coins');
        }
      }
    }
    if (!isMoving) {
      if (waitTime < 5) {
        waitTime += dt;
      } else {
        waitTime = 0;
        generateNewRoute();
      }
    }
  }

  double waitTime = 0;

  @override
  void render(ui.Canvas canvas) {
    canvas.drawCircle(
      Offset.zero,
      16,
      ui.Paint()
        ..color =
            isMoving ? const ui.Color(0xFF00FF00) : const Color(0xFFFF0000),
    );
    ui.ParagraphBuilder builder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center,
      fontSize: 10,
    ))
      ..pushStyle(ui.TextStyle(
          color: Colors.white,
          background: ui.Paint()..color = const ui.Color(0xFF000000)))
      ..addText(isMoving
          ? '(X: ${position.x.toInt()}, Y: ${position.y.toInt()})'
          : 'Waiting: ${waitTime.toStringAsFixed(2)}s');

    final paragraph = builder.build()
      ..layout(ui.ParagraphConstraints(width: size.x * 3));

    canvas.drawParagraph(paragraph, Offset.zero);

    super.render(canvas);
  }
}
