import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart' as flame_events;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import '../core/constants/city_names.dart';
import '../core/constants/game_constants.dart';
import '../data/enums/map_tile_type.dart';
import '../data/models/json_map_tile.dart';
import '../data/models/map_tile.dart';
import '../data/models/map_tile_position.dart';
import '../data/models/vehicle.dart';
import '../features/game_alerts/bloc/game_alerts_event.dart';
import '../utils/map_extension.dart';
import '../utils/path_extension.dart';
import '../utils/random_data_generator.dart';
import 'city_tile.dart';
import 'game_tile.dart';
import 'game_vehicle.dart';
import 'multi_path_finder.dart';
import 'path_component.dart';
import 'path_finder.dart';
import 'transport_game.dart';
import 'utils/vector2_extension.dart';

class TransportWorld extends World
    with HasGameRef<TransportGame>, flame_events.TapCallbacks {
  final List<List<MapTile>> tiles = <List<MapTile>>[];

  Vector2 position = Vector2.all(GameConstants.mapTileSize);
  Vector2? targetPosition;
  static const double speed = 200.0;

  /// Put vehicle on map, when it has moving
  bool showTruckWithRoute(Vehicle vehicle, List<Vector2> positions) {
    final path = TwoPhasePathFinder(tiles).findPath(positions);
    if (path.isEmpty) {
      return false;
    }
    final String pathId = const Uuid().v4();
    final PathComponent pathComponent = PathComponent(
      pathPoints: path,
      color: getRandomColor(),
      pathId: pathId,
    );
    final pathLength = path.calculatePathLength();

    final isEnoughFuel = vehicle.hasEnoughFuel(pathLength);
    final neededFuel = pathLength * vehicle.fuelPerPixel;
    if (!isEnoughFuel) {
      game.alertsBloc.add(
        GameAlertNotEnoughFuel(neededFuel - vehicle.currentFuelLevel),
      );
      return false;
    }

    final GameVehicle truck = GameVehicle(
      path: path,
      pathId: pathId,
      position: pathComponent.pathPoints.first.position,
      vehicle: vehicle,
    );
    add(pathComponent);
    add(truck);
    return true;
  }

  bool isConnectedToRoad(Vector2 gridPosition) {
    return tiles.isRoadNearby(gridPosition.toMapTilePosition());
  }

  void openCityOverview(Vector2 gridPosition, String cityName) {
    game.openCityOverview(gridPosition, cityName);
  }

  void openGarageOverview(Vector2 gridPosition) {
    game.openGarageOverview(gridPosition);
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

  int calculateMaxCities(int mapWidth, int mapHeight, int minDistance) {
    // Calculate the number of cells in the grid
    final int cellsX = (mapWidth / minDistance).floor();
    final int cellsY = (mapHeight / minDistance).floor();

    // The maximum number of cities is the number of cells in the grid
    return cellsX * cellsY;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Load map
    final data = await rootBundle.loadString('assets/map/map.json');
    final jsonValue = jsonDecode(data) as List<dynamic>;
    tiles.addAll(
      List.generate(
        GameConstants.mapYSize,
        (int y) => List.generate(
          GameConstants.mapXSize,
          (int x) => MapTile(
            type: MapTileType.forest,
            position: MapTilePosition(
              x: x.toDouble(),
              y: y.toDouble(),
            ),
          ),
        ),
      ),
    );

    // Populate map
    for (final row in jsonValue) {
      final jsonTile = JsonMapTile.fromJson(row);
      final mapTile = MapTile(
        position: MapTilePosition(x: jsonTile.x, y: jsonTile.y),
        type: jsonTile.type,
        isUnlocked: jsonTile.type == MapTileType.headquarter,
      );
      tiles[jsonTile.y.toInt() + GameConstants.mapYHalf]
          [jsonTile.x.toInt() + GameConstants.mapXHalf] = mapTile;
    }

    for (final row in tiles) {
      for (final tile in row) {
        final gameTile = buildGameTile(tile: tile);
        add(gameTile);
      }
    }
  }

  GameTile buildGameTile({
    required MapTile tile,
  }) {
    return switch (tile.type) {
      MapTileType.city => CityTile(
          gridPosition: tile.position.toVector2(),
          isDiscovered: tile.isUnlocked,
          cityName: cityNames[
              (tile.position.x + tile.position.y).toInt() % cityNames.length],
        ),
      MapTileType.headquarter => GameTile(
          type: tile.type,
          gridPosition: tile.position.toVector2(),
          isDiscovered: tile.isUnlocked,
        ),
      _ => GameTile(
          type: tile.type,
          isDiscovered: tile.isUnlocked,
          gridPosition: tile.position.toVector2(),
        )
    };
  }

  void _connectCitiesWithRoad(List<Vector2> citiesPositions) {
    if (citiesPositions.isEmpty) {
      return;
    }

    for (int i = 0; i < citiesPositions.length; i++) {
      for (int j = 0; j < citiesPositions.length; j++) {
        if (i == j) {
          continue;
        }
        final Vector2 start = citiesPositions[i];
        final Vector2 end = citiesPositions[j];

        final startX = start.x;
        final endX = end.x;
        final startY = start.y;
        final endY = end.y;
        int currentX = startX.toInt();
        int currentY = startY.toInt();

        if (startX < endX) {
          while (currentX < endX) {
            currentX += 1;
            _buildRoad(currentX, currentY);
          }
        } else {
          while (currentX > endX) {
            currentX -= 1;
            _buildRoad(currentX, currentY);
          }
        }
        if (startY < endY) {
          while (currentY < endY) {
            currentY += 1;
            _buildRoad(currentX, currentY);
          }
        } else {
          while (currentY > endY) {
            currentY -= 1;
            _buildRoad(currentX, currentY);
          }
        }
      }
    }
  }

  void _buildRoad(int x, int y) {
    if (x >= -1 && x <= 1 && y >= -1 && y <= 1) {
      return;
    }
    final tile = tiles[y + GameConstants.mapYHalf][x + GameConstants.mapXHalf];
    if (tile.type == MapTileType.city) {
      return;
    }

    tiles[y + GameConstants.mapYHalf][x + GameConstants.mapXHalf] =
        tile.copyWith(type: MapTileType.road);
  }

  MapTileType _generateTileType() {
    final Random random = Random();
    final double value = random.nextDouble();

    if (value < 0.1) {
      return MapTileType.farmland;
    }

    if (value < 0.15) {
      return MapTileType.savanna;
    }
    if (value < 0.2) {
      return MapTileType.tundra;
    }
    if (value < 0.4) {
      return MapTileType.mountain;
    }
    if (value < 0.6) {
      return MapTileType.gravel;
    }

    return MapTileType.forest;
  }
}
