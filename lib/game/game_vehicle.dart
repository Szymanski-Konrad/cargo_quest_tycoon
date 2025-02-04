import 'dart:ui' as ui;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../data/models/vehicle.dart';
import '../features/vehicles_management/bloc/vehicles_management_event.dart';
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
  late final RectangleHitbox hitbox;
  final ui.Color baseColor = Colors.black;
  Vehicle vehicle;

  // @override
  // Future<void> onLoad() async {
  //   super.onLoad();
  //   hitbox =
  //       RectangleHitbox(size: Vector2(32, 32), position: Vector2(-16, -16));
  //   add(hitbox);
  // }

  void updateFuel(double distance, double dt) {
    final double fuelConsumption = vehicle.fuelPerPixel * distance;
    vehicle = vehicle.copyWith(
      currentFuelLevel: vehicle.currentFuelLevel - fuelConsumption,
    );
    world.game.vehiclesBloc.add(VehicleFuelBurned(vehicle.id, fuelConsumption));
  }

  @override
  void update(double dt) {
    if (path.isNotEmpty) {
      final PathTile nextPosition = path[currentPathIndex];
      final Vector2 direction = (nextPosition.position - position).normalized();
      velocity.setValues(direction.x, direction.y);
      // TODO(me): Calculate used fuel just from actual speed and passed time [dt]
      final Vector2 positionDelta =
          velocity * vehicle.terrainSpeed(nextPosition.type) * dt * 2;
      final Vector2 tempPosition = position.clone();
      position.add(positionDelta);
      final double distance = tempPosition.distanceTo(position);
      updateFuel(distance, dt);

      if (position.distanceTo(nextPosition.position) < 1) {
        currentPathIndex++;
        if (currentPathIndex >= path.length) {
          world.removePath(pathId);
          world.remove(this);
          world.game.truckArrived(vehicle);
        }
      }
    }
  }

  @override
  void render(ui.Canvas canvas) {
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
      ..addText(
          '${(vehicle.currentFuelLevel * 100 / vehicle.fuelCapacity).toStringAsFixed(1)}%');

    final ui.Paragraph paragraph = builder.build()
      ..layout(ui.ParagraphConstraints(width: size.x * 2));

    canvas.drawParagraph(paragraph, Offset.zero);

    super.render(canvas);
  }
}
