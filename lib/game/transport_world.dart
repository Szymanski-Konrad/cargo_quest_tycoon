import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart' as flame_events;
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../core/constants/game_constants.dart';
import '../core/constants/generated_map.dart';
import '../data/enums/map_tile_type.dart';
import '../data/models/map_tile.dart';
import '../data/models/vehicle.dart';
import 'city_tile.dart';
import 'game_tile.dart';
import 'game_vehicle.dart';
import 'path_component.dart';
import 'path_finder.dart';
import 'transport_game.dart';
import 'utils/vector2_extension.dart';

class TransportWorld extends World
    with HasGameRef<TransportGame>, flame_events.TapCallbacks {
  final List<List<GameTile>> tiles = <List<GameTile>>[];

  Vector2 position = Vector2.all(GameConstants.mapTileSize);
  Vector2? targetPosition;
  static const double speed = 200.0;

  GameTile? findClosestTile(Vector2 tappedPosition) {
    GameTile? closestTile;

    for (final List<GameTile> row in tiles) {
      for (final GameTile tile in row) {
        if (tile.containsPoint(tappedPosition)) {
          closestTile = tile;
        }
      }
    }

    return closestTile;
  }

  /// Put vehicle on map, when it has moving
  void showTruckWithRoute(
      Vehicle vehicle, Vector2 startPosition, Vector2 targetPosition) {
    final List<PathTile> path =
        PathFinder(tiles).findPath(startPosition, targetPosition);
    for (final item in path) {
      print(item.position);
    }
    final String pathId = const Uuid().v4();
    final PathComponent pathComponent = PathComponent(
      pathPoints: path,
      color: getRandomColor(),
      pathId: pathId,
    );
    final GameVehicle truck = GameVehicle(
      path: path,
      pathId: pathId,
      position: pathComponent.pathPoints.first.position,
      vehicle: vehicle,
    );
    add(pathComponent);
    add(truck);
  }

  void openCityOverview(Vector2 gridPosition) {
    game.openCityOverview(gridPosition);
  }

  Color getRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255, // Alpha value (fully opaque)
      random.nextInt(256), // Red value
      random.nextInt(256), // Green value
      random.nextInt(256), // Blue value
    );
  }

  void removePath(String pathId) {
    final PathComponent? path = children
        .whereType<PathComponent>()
        .firstWhereOrNull((PathComponent element) => element.pathId == pathId);
    final Iterable<PathComponent> paths = children.whereType<PathComponent>();
    final Iterable<String> vehiclePaths = children
        .whereType<GameVehicle>()
        .map((GameVehicle item) => item.pathId);
    for (final PathComponent leftPath in paths) {
      if (vehiclePaths.contains(leftPath.pathId)) {
        continue;
      }
      remove(leftPath);
    }

    if (path != null) {
      remove(path);
    }
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Generate map
    int number = 1;

    final int xHalf = (GameConstants.mapXSize / 2).ceil();
    final int yHalf = (GameConstants.mapYSize / 2).ceil();
    for (int y = -yHalf; y < GameConstants.mapYSize - yHalf; y++) {
      final List<GameTile> row = <GameTile>[];
      for (int x = -xHalf; x < GameConstants.mapXSize - xHalf; x++) {
        final MapTileType type =
            y == 0 && x == 0 ? MapTileType.headquarter : _generateTileType();
        final GameTile tile = buildGameTile(
          type: type,
          number: number,
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

    await _ensurePathsBetweenCities();
    for (final List<GameTile> row in tiles) {
      final List<MapTile> mapRow = <MapTile>[];
      for (final GameTile tile in row) {
        mapRow.add(MapTile(
          position: tile.gridPosition.toMapTilePosition(),
          type: tile.type,
          isUnlocked: tile.isDiscovered,
        ));
      }
      mapTiles.add(mapRow);
    }
  }

  GameTile buildGameTile({
    required MapTileType type,
    required int number,
    required Vector2 gridPosition,
  }) {
    return switch (type) {
      MapTileType.city => CityTile(
          number: number,
          gridPosition: gridPosition,
        ),
      MapTileType.headquarter => GameTile(
          number: number,
          type: type,
          gridPosition: gridPosition,
          isDiscovered: true,
        ),
      _ => GameTile(
          number: number,
          type: type,
          gridPosition: gridPosition,
        )
    };
  }

  Future<void> _ensurePathsBetweenCities() async {
    final List<GameTile> cities = tiles
        .expand((List<GameTile> row) => row)
        .where((GameTile tile) => tile.type == MapTileType.city)
        .toList();
    if (cities.isEmpty) {
      return;
    }

    for (int i = 0; i < cities.length; i++) {
      for (int j = 0; j < cities.length; j++) {
        if (i == j) {
          continue;
        }
        final GameTile start = cities[i];
        final GameTile end = cities[j];
        final List<PathTile> path =
            PathFinder(tiles).findPath(start.position, end.position);

        for (final PathTile point in path) {
          final GameTile? tile = tiles.flattened.firstWhereOrNull(
              (GameTile testTile) => testTile.containsPoint(point.position));
          if (tile == null) {
            continue;
          }
          if (!tile.type.isDrivable) {
            tile.type = MapTileType.road;
          }
        }
      }
    }
  }

  MapTileType _generateTileType() {
    final Random random = Random();
    final double value = random.nextDouble();

    if (value < 0.2) {
      return MapTileType.water;
    }
    if (value < 0.4) {
      return MapTileType.forest;
    }
    if (value < 0.6) {
      return MapTileType.mountain;
    }
    if (value < 0.7) {
      return MapTileType.road;
    }
    if (value < 0.8) {
      return MapTileType.city;
    }
    return MapTileType.gravel;
  }
}
