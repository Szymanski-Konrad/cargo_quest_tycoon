import 'dart:async';
import 'dart:ui' as ui;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../data/models/vehicle.dart';
import 'bloc/game_bloc.dart';
import 'path_finder.dart';
import 'transport_world.dart';

class GameVehicle extends PositionComponent
    with HasWorldReference<TransportWorld>, GestureHitboxes {
  GameVehicle({
    required Vector2 position,
    required this.path,
    required this.pathId,
    required this.vehicle,
  }) : super(position: position, size: Vector2(32, 32));
  final Vector2 velocity = Vector2.zero();
  final List<PathTile> path;
  final String pathId;
  int currentPathIndex = 0;
  bool returnToBase = false;
  late final RectangleHitbox hitbox;
  final ui.Color baseColor = Colors.black;
  Vehicle vehicle;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    hitbox =
        RectangleHitbox(size: Vector2(32, 32), position: Vector2(-16, -16));
    add(hitbox);
  }

  void generateReturnRoute() {
    returnToBase = true;
    final List<PathTile> returnPath = path.reversed.toList();
    path.clear();
    path.addAll(returnPath);
    currentPathIndex = 0;
    position.setValues(path.first.position.x, path.first.position.y);
  }

  void updateFuel(double distance, double dt) {
    final double fuelConsumption = vehicle.fuelPerPixel * distance;
    vehicle = vehicle.copyWith(
      currentFuelLevel: vehicle.currentFuelLevel - fuelConsumption,
    );
  }

  @override
  void update(double dt) {
    if (path.isNotEmpty) {
      final PathTile nextPosition = path[currentPathIndex];
      final Vector2 direction = (nextPosition.position - position).normalized();
      velocity.setValues(direction.x, direction.y);
      // TODO(me): Calculate used fuel just from actual speed and passed time [dt]
      final Vector2 positionDelta =
          velocity * vehicle.terrainSpeed(nextPosition.type) * dt;
      final Vector2 tempPosition = position.clone();
      position.add(positionDelta);
      final double distance = tempPosition.distanceTo(position);
      updateFuel(distance, dt);

      if (position.distanceTo(nextPosition.position) < 1) {
        currentPathIndex++;
        if (currentPathIndex >= path.length) {
          if (returnToBase) {
            final double coins = path.length * vehicle.maxCargoWeight;
            world.game.gameBloc.add(GainCoins(coins.toInt()));
            world.removePath(pathId);
            // TODO(me): Inform that truck end his route
            world.remove(this);
            world.game.showAlert('Truck delivered $coins coins');
            world.game.showAlert('Truck arrived at destination');
          } else {
            generateReturnRoute();
          }
        }
      }
    }
  }

  @override
  void render(ui.Canvas canvas) {
    final String speed =
        vehicle.terrainSpeed(path[currentPathIndex].type).toStringAsFixed(1);
    canvas.drawCircle(
      Offset.zero,
      16,
      ui.Paint()..color = const ui.Color(0xFF00FF00),
    );
    final ui.ParagraphBuilder builder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center,
      fontSize: 10,
    ))
      ..pushStyle(ui.TextStyle(
          color: Colors.white,
          background: ui.Paint()..color = const ui.Color(0xFF000000)))
      ..addText('Speed: $speed, to base: $returnToBase');

    final ui.Paragraph paragraph = builder.build()
      ..layout(ui.ParagraphConstraints(width: size.x * 2));

    canvas.drawParagraph(paragraph, Offset.zero);

    super.render(canvas);
  }
}
