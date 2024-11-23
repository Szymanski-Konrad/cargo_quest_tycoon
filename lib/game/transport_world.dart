import 'dart:math';

import 'package:cargo_quest_tycoon/core/constants/game_constants.dart';
import 'package:cargo_quest_tycoon/data/enums/map_tile_type.dart';
import 'package:cargo_quest_tycoon/game/bloc/game_bloc.dart';
import 'package:cargo_quest_tycoon/game/game_tile.dart';
import 'package:cargo_quest_tycoon/game/game_vehicle.dart';
import 'package:cargo_quest_tycoon/game/path_component.dart';
import 'package:cargo_quest_tycoon/game/path_finder.dart';
import 'package:cargo_quest_tycoon/game/transport_game.dart';
import 'package:collection/collection.dart';
import 'package:flame/camera.dart';
import 'package:flame/events.dart' as flame_events;
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

class TransportWorld extends World
    with HasGameRef<TransportGame>, flame_events.TapCallbacks {
  final List<List<GameTile>> tiles = [];

  Vector2 position = Vector2.all(GameConstants.mapTileSize);
  Vector2? targetPosition;
  static const speed = 200.0;

  GameTile? findClosestTile(Vector2 tappedPosition) {
    GameTile? closestTile;

    for (var row in tiles) {
      for (var tile in row) {
        if (tile.containsPoint(tappedPosition)) {
          closestTile = tile;
        }
      }
    }

    return closestTile;
  }

  (List<Vector2>, String) generatePath(Vector2 position) {
    final randomCity = tiles
        .expand((element) => element)
        .where((element) => element.type == MapTileType.city)
        .toList()
      ..shuffle();
    final destination = randomCity.first.position;
    final path = PathFinder(tiles).findPath(position, destination);
    final pathId = const Uuid().v4();
    if (path.isNotEmpty) {
      final pathComponent = PathComponent(
        pathPoints: path,
        color: getRandomColor(),
        pathId: pathId,
      );
      add(pathComponent);
    }
    return (path, pathId);
  }

  void addTruck(Vector2 position) {
    if (game.gameBloc.state.coins < 500) {
      print('Not enough coins');
      return;
    }
    ;
    final (path, pathId) = generatePath(position);
    if (path.isEmpty) {
      print('No path found');
      return;
    }
    GameVehicle truck = GameVehicle(position: position);
    truck.setDestination(path, pathId);
    game.gameBloc.add(GameGainCoins(-500));
    add(truck);
  }

  Color getRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255, // Alpha value (fully opaque)
      random.nextInt(256), // Red value
      random.nextInt(256), // Green value
      random.nextInt(256), // Blue value
    );
  }

  void removePath(String pathId) {
    final path = children
        .whereType<PathComponent>()
        .firstWhereOrNull((element) => element.pathId == pathId);
    if (path != null) remove(path);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Generate map
    int number = 1;
    final center = GameConstants.mapSize / 2.ceil();
    for (var y = 0; y < GameConstants.mapYSize; y++) {
      final row = <GameTile>[];
      for (var x = 0; x < GameConstants.mapXSize; x++) {
        final tile = GameTile(
          number: number,
          type: number == center
              ? MapTileType.headquarter
              : _generateTileType(x, y),
          gridPosition: Vector2(
            (x + 0).toDouble(),
            (y + 0).toDouble(),
          ),
        );
        row.add(tile);
        add(tile);
        number++;
      }
      tiles.add(row);
    }
  }

  MapTileType _generateTileType(int x, int y) {
    final random = Random();
    final value = random.nextDouble();

    if (value < 0.1) return MapTileType.port;
    if (value < 0.2) return MapTileType.water;
    if (value < 0.4) return MapTileType.forest;
    if (value < 0.6) return MapTileType.mountain;
    if (value < 0.7) return MapTileType.road;
    if (value < 0.8) return MapTileType.city;
    return MapTileType.empty;
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
