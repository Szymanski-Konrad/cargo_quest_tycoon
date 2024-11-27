import 'dart:math';

import 'package:cargo_quest_tycoon/core/constants/game_constants.dart';
import 'package:cargo_quest_tycoon/data/enums/map_tile_type.dart';
import 'package:cargo_quest_tycoon/data/models/vehicle.dart';
import 'package:cargo_quest_tycoon/game/game_tile.dart';
import 'package:cargo_quest_tycoon/game/game_vehicle.dart';
import 'package:cargo_quest_tycoon/game/path_component.dart';
import 'package:cargo_quest_tycoon/game/path_finder.dart';
import 'package:cargo_quest_tycoon/game/transport_game.dart';
import 'package:cargo_quest_tycoon/utils/path_extension.dart';
import 'package:collection/collection.dart';
import 'package:flame/events.dart' as flame_events;
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
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

  GameTile? assignCityToTruck() => (tiles
          .expand((element) => element)
          .where((element) => element.type == MapTileType.city)
          .toList()
        ..shuffle())
      .first;

  (List<PathTile>, String) generatePath(
    Vector2 position, {
    Vector2? target,
    double maxDistance = double.infinity,
  }) {
    final randomCities = tiles
        .expand((element) => element)
        .where((element) => element.type == MapTileType.city)
        .toList()
      ..shuffle();

    List<PathTile> path = [];
    for (final city in randomCities.take(5)) {
      final path = PathFinder(tiles).findPath(position, city.position);
      final distance = path.calculatePathLength();
      if (path.isNotEmpty && distance > 0 && distance < maxDistance) {
        final pathId = const Uuid().v4();
        final pathComponent = PathComponent(
          pathPoints: path,
          color: getRandomColor(),
          pathId: pathId,
        );
        add(pathComponent);
        return (path, pathId);
      } else {
        // print(
        // 'Path to city ${city.number} is too long, ${maxDistance} -> $distance');
      }
    }

    print('No path found for max distance $maxDistance');
    return ([], '');
  }

  void openVehicleShop(Vector2 position) {
    game.openVehicleShop();
  }

  void addTruck(Vehicle vehicle) {
    final target = tiles
        .expand((element) => element)
        .firstWhereOrNull((element) => element.type == MapTileType.headquarter);
    if (target == null) {
      return;
    }

    GameVehicle truck = GameVehicle(
      position: target.position,
      vehicle: vehicle,
    );
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
    final paths = children.whereType<PathComponent>();
    final vehiclePaths = children
        .whereType<GameVehicle>()
        .map((item) => item.pathId)
        .whereNot((item) => item == null);
    for (final leftPath in paths) {
      if (vehiclePaths.contains(leftPath.pathId)) {
        continue;
      }
      remove(leftPath);
    }

    if (path != null) remove(path);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Generate map
    int number = 1;
    final center = (GameConstants.mapSize / 2).ceil();
    final xHalf = (GameConstants.mapXSize / 2).ceil();
    final yHalf = (GameConstants.mapYSize / 2).ceil();
    for (var y = -yHalf; y < GameConstants.mapYSize - yHalf; y++) {
      final row = <GameTile>[];
      for (var x = -xHalf; x < GameConstants.mapXSize - xHalf; x++) {
        final tile = GameTile(
          number: number,
          type:
              number == center ? MapTileType.headquarter : _generateTileType(),
          gridPosition: Vector2(
            x.toDouble(),
            y.toDouble(),
          ),
        );
        row.add(tile);
        add(tile);
        number++;
      }
      tiles.add(row);
    }

    _ensurePathsBetweenCities();
  }

  Future<void> _ensurePathsBetweenCities() async {
    final cities = tiles
        .expand((row) => row)
        .where((tile) => tile.type == MapTileType.city)
        .toList();
    if (cities.isEmpty) return;

    for (int i = 0; i < cities.length; i++) {
      for (int j = 0; j < cities.length; j++) {
        if (i == j) continue;
        final start = cities[i];
        final end = cities[j];
        final path =
            PathFinder(tiles).findPath(start.gridPosition, end.gridPosition);

        for (final point in path) {
          final tile = tiles.flattened.firstWhereOrNull(
              (testTile) => testTile.containsPoint(point.position));
          if (tile == null) {
            continue;
          }
          if (!tile.type.isDrivable) {
            await Future.delayed(const Duration(seconds: 1));
            tile.type = MapTileType.road;
          }
        }
      }
    }
  }

  MapTileType _generateTileType() {
    final random = Random();
    final value = random.nextDouble();

    if (value < 0.2) return MapTileType.water;
    if (value < 0.4) return MapTileType.forest;
    if (value < 0.6) return MapTileType.mountain;
    if (value < 0.7) return MapTileType.road;
    if (value < 0.8) return MapTileType.city;
    return MapTileType.gravel;
  }
}
