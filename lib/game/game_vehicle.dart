import 'dart:async';
import 'dart:ui' as ui;
import 'package:cargo_quest_tycoon/data/models/vehicle.dart';
import 'package:cargo_quest_tycoon/features/fuel_stations/bloc/fuel_stations_event.dart';
import 'package:cargo_quest_tycoon/game/bloc/game_bloc.dart';
import 'package:cargo_quest_tycoon/game/game_tile.dart';
import 'package:cargo_quest_tycoon/game/path_finder.dart';
import 'package:cargo_quest_tycoon/utils/path_extension.dart';
import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import 'package:cargo_quest_tycoon/game/transport_world.dart';
import 'package:flame/components.dart';

class GameVehicle extends PositionComponent
    with HasWorldReference<TransportWorld>, TapCallbacks, GestureHitboxes {
  final Vector2 velocity = Vector2.zero();
  final List<PathTile> path = [];
  String? pathId;
  int currentPathIndex = 0;
  bool isMoving = false;
  bool returnToBase = false;
  late final RectangleHitbox hitbox;
  final baseColor = Colors.black;
  final hoverColor = Colors.teal;
  Vehicle vehicle;
  GameTile? assignedCity;

  GameVehicle({
    required Vector2 position,
    required this.vehicle,
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
    if (assignedCity != null) {
      if (path.isEmpty) generateNewRoute();
    } else {
      assignedCity = world.assignCityToTruck();
      position.setValues(assignedCity!.position.x, assignedCity!.position.y);
    }

    super.onTapUp(event);
  }

  void generateNewRoute() {
    try {
      //TODO: Calculate max distance and pass it to generate path
      final maxDistance = vehicle.maxDistance();

      final (path, pathId) =
          world.generatePath(position, maxDistance: maxDistance);
      final pathDistance = path.calculatePathLength();
      print('Vehicle max distance: $maxDistance');
      print(
          'Vehicle need fuel ${vehicle.fuelPerPixel * pathDistance}, for distance: $pathDistance, vehicle fuel: ${vehicle.currentFuelLevel}');
      if (vehicle.hasEnoughFuel(pathDistance * 2)) {
        returnToBase = false;
        setDestination(path, pathId);
      } else {
        world.game.showAlert('Truck ran out of fuel');
      }
    } catch (e) {
      print('Error generating path: $e');
    }
  }

  void generateReturnRoute() {
    print('Generating return route');
    returnToBase = true;
    setDestination(path.reversed.toList(), pathId ?? '');
  }

  void setDestination(List<PathTile> path, String id) {
    pathId = id;
    if (path.isEmpty) {
      print('No path found');
      return;
    }
    if (path.isNotEmpty) {
      this.path.clear();
      this.path.addAll(path);
      currentPathIndex = 0;
      position.setValues(path.first.position.x, path.first.position.y);
      isMoving = true;
    }
  }

  void updateFuel(double? distance, double dt) {
    if (isMoving) {
      if (distance == null) return;
      final fuelConsumption = vehicle.fuelPerPixel * distance;
      vehicle = vehicle.copyWith(
        currentFuelLevel: vehicle.currentFuelLevel - fuelConsumption,
      );
    } else if (vehicle.currentFuelLevel < vehicle.fuelCapacity) {
      final refillFuel =
          world.game.stationsBloc.state.primary.vehicleRefillRate * dt;
      if (world.game.stationsBloc.state.primary.currentFuelLevel >=
          refillFuel) {
        vehicle = vehicle.copyWith(
          currentFuelLevel: vehicle.currentFuelLevel + refillFuel,
        );

        world.game.stationsBloc.add(
          FuelStationsEventRefillVehicle('primary', refillFuel),
        );
      }
    }
  }

  @override
  void update(double dt) {
    if (isMoving && path.isNotEmpty) {
      final nextPosition = path[currentPathIndex];
      final direction = (nextPosition.position - position).normalized();
      velocity.setValues(direction.x, direction.y);
      final positionDelta =
          velocity * vehicle.terrainSpeed(nextPosition.type) * dt;
      final tempPosition = position.clone();
      position.add(positionDelta);
      final distance = tempPosition.distanceTo(position);
      updateFuel(distance, dt);

      if (position.distanceTo(nextPosition.position) < 1) {
        currentPathIndex++;
        if (currentPathIndex >= path.length) {
          isMoving = false;
          if (returnToBase && pathId != null) world.removePath(pathId!);
          if (!returnToBase) {
            final coins = path.length * vehicle.maxCargoWeight;
            world.game.gameBloc.add(GainCoins(coins.toInt()));
            world.game.showAlert('Truck delivered $coins coins');
            waitTime = 0;
            generateReturnRoute();
          }
        }
      }
    }
    if (!isMoving) {
      if (waitTime > 5) {
        waitTime = 0;
        generateNewRoute();
      } else {
        waitTime += dt;
        updateFuel(null, dt);
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
          ? 'Speed: ${vehicle.terrainSpeed(path[currentPathIndex].type).toStringAsFixed(1)}, fuel: ${(100 * vehicle.currentFuelLevel / vehicle.fuelCapacity).toStringAsFixed(2)}%, coins: ${path.length * vehicle.maxCargoWeight}\$'
          : 'Waiting: ${waitTime.toStringAsFixed(2)}s, fuel: ${(100 * vehicle.currentFuelLevel / vehicle.fuelCapacity).toStringAsFixed(1)}%, maxDistance: ${vehicle.maxDistance().toStringAsFixed(1)}');

    final paragraph = builder.build()
      ..layout(ui.ParagraphConstraints(width: size.x * 2.5));

    canvas.drawParagraph(paragraph, Offset.zero);

    super.render(canvas);
  }
}
