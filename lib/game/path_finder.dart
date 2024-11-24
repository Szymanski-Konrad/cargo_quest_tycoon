// Node class for A* algorithm
import 'dart:collection';

import 'package:cargo_quest_tycoon/core/constants/game_constants.dart';
import 'package:cargo_quest_tycoon/data/enums/map_tile_type.dart';
import 'package:cargo_quest_tycoon/game/game_tile.dart';
import 'package:flame/components.dart';

class PathNode {
  final Vector2 position;
  final double g; // Cost from start
  final double h; // Estimated cost to end
  final PathNode? parent;

  // Total cost
  double get f => g + h;

  // For HashSet comparison
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PathNode &&
          position.x == other.position.x &&
          position.y == other.position.y;

  @override
  int get hashCode => position.hashCode;

  PathNode(this.position, this.g, this.h, this.parent);
}

class PathFinder {
  final xHalf = (GameConstants.mapXSize / 2).ceil();
  final yHalf = (GameConstants.mapYSize / 2).ceil();

  final List<List<GameTile>> map;
  final double straightCost = 1.0;

  // Movement costs for different tile types
  final Map<MapTileType, double> terrainCosts = {
    MapTileType.road: 1.0,
    MapTileType.city: 1.0,
    MapTileType.headquarter: 1.0,
    MapTileType.port: 1.0,
    MapTileType.empty: 2.0,
    MapTileType.forest: 3.0,
    MapTileType.mountain: double.infinity,
    MapTileType.water: double.infinity,
  };

  PathFinder(this.map);

  List<Vector2> findPath(Vector2 start, Vector2 end) {
    // Convert positions to grid coordinates
    final startGrid = _worldToGrid(start);
    final endGrid = _worldToGrid(end);

    // Check if start or end is invalid
    if (!_isValidPosition(startGrid) || !_isValidPosition(endGrid)) {
      print('Invalid start or end position');
      return [];
    }

    final openSet = HashSet<PathNode>();
    final closedSet = HashSet<PathNode>();

    openSet.add(
        PathNode(startGrid, 0, _calculateHeuristic(startGrid, endGrid), null));

    while (openSet.isNotEmpty) {
      // Get node with lowest f cost
      final current = openSet.reduce((a, b) => a.f < b.f ? a : b);

      // Check if we reached the end
      if ((current.position - endGrid).length < 0.1) {
        return _reconstructPath(current);
      }

      openSet.remove(current);
      closedSet.add(current);

      // Check all neighbors
      for (final neighbor in _getNeighbors(current)) {
        // Skip if already evaluated
        if (closedSet.contains(neighbor)) continue;

        final tentativeG = current.g +
            _calculateMovementCost(current.position, neighbor.position);

        // Check if this path is better
        if (!openSet.contains(neighbor)) {
          openSet.add(PathNode(neighbor.position, tentativeG,
              _calculateHeuristic(neighbor.position, endGrid), current));
        } else {
          final existingNode = openSet.lookup(neighbor);
          if (existingNode != null && tentativeG < existingNode.g) {
            openSet.remove(existingNode);
            openSet.add(PathNode(
                neighbor.position, tentativeG, existingNode.h, current));
          }
        }
      }
    }

    return []; // No path found
  }

  double _calculateHeuristic(Vector2 start, Vector2 end) {
    // Manhattan distance
    return (end.x - start.x).abs() + (end.y - start.y).abs();
  }

  List<PathNode> _getNeighbors(PathNode node) {
    final List<PathNode> neighbors = [];
    final directions = [
      Vector2(1, 0), // right
      Vector2(-1, 0), // left
      Vector2(0, 1), // down
      Vector2(0, -1), // up
    ];

    for (final dir in directions) {
      final newPos = node.position + dir;

      if (_isValidPosition(newPos)) {
        final tileType = map[newPos.y.toInt() + yHalf.ceil()]
                [newPos.x.toInt() + xHalf.ceil()]
            .type;
        final movementCost = terrainCosts[tileType] ?? double.infinity;

        // Skip unwalkable tiles
        if (movementCost == double.infinity) continue;

        neighbors.add(PathNode(
            newPos,
            0, // g cost will be calculated later
            0, // h cost will be calculated later
            node));
      }
    }

    return neighbors;
  }

  bool _isValidPosition(Vector2 pos) {
    return pos.x >= -xHalf && pos.x < xHalf && pos.y >= -yHalf && pos.y < yHalf;
  }

  double _calculateMovementCost(Vector2 from, Vector2 to) {
    // Get terrain costs for both tiles
    final fromType =
        map[from.y.toInt() + yHalf.ceil()][from.x.toInt() + xHalf.ceil()].type;
    final toType =
        map[to.y.toInt() + yHalf.ceil()][to.x.toInt() + xHalf.ceil()].type;

    final fromCost = terrainCosts[fromType] ?? double.infinity;
    final toCost = terrainCosts[toType] ?? double.infinity;

    // Use average of both tiles' costs
    return straightCost * (fromCost + toCost) / 2;
  }

  List<Vector2> _reconstructPath(PathNode endNode) {
    final path = <Vector2>[];
    var current = endNode;

    while (current.parent != null) {
      path.add(_gridToWorld(current.position));
      current = current.parent!;
    }

    // Add start position
    path.add(_gridToWorld(current.position));

    // Smooth path
    return path.reversed.toList();
  }

  Vector2 _worldToGrid(Vector2 worldPos) {
    return Vector2((worldPos.x / GameConstants.mapTileSize).floor().toDouble(),
        (worldPos.y / GameConstants.mapTileSize).floor().toDouble());
  }

  Vector2 _gridToWorld(Vector2 gridPos) {
    return Vector2(
      gridPos.x * GameConstants.mapTileSize +
          (GameConstants.mapTileSize / 2), // Center of tile
      gridPos.y * GameConstants.mapTileSize + (GameConstants.mapTileSize / 2),
    );
  }
}
