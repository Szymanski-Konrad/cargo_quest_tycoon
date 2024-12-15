// Node class for A* algorithm
import 'dart:collection';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../core/constants/game_constants.dart';
import '../data/enums/map_tile_type.dart';
import 'game_tile.dart';

class PathTile {
  PathTile(this.position, this.type);
  final Vector2 position;
  final MapTileType type;
}

@immutable
class PathNode {
  const PathNode(this.position, this.g, this.h, this.parent);
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
}

class PathFinder {
  PathFinder(this.map);
  final int xHalf = (GameConstants.mapXSize / 2).ceil();
  final int yHalf = (GameConstants.mapYSize / 2).ceil();

  final List<List<GameTile>> map;
  final double straightCost = 1.0;

  // Movement costs for diffe rent tile types
  final Map<MapTileType, double> terrainCosts = <MapTileType, double>{
    MapTileType.road: 1.0,
    MapTileType.city: 1.0,
    MapTileType.headquarter: 1.0,
    MapTileType.gravel: 2.0,
    MapTileType.forest: 3.0,
    MapTileType.mountain: double.infinity,
    MapTileType.water: double.infinity,
  };

  List<PathTile> findPath(Vector2 start, Vector2 end) {
    // Convert positions to grid coordinates
    final Vector2 startGrid = _worldToGrid(start);
    final Vector2 endGrid = _worldToGrid(end);
    print('Before Start grid: $start, end grid: $end');
    print('Start grid: $startGrid, end grid: $endGrid');

    // Check if start or end is invalid
    if (!_isValidPosition(startGrid) || !_isValidPosition(endGrid)) {
      debugPrint('Invalid start or end position');
      return <PathTile>[];
    }

    final HashSet<PathNode> openSet = HashSet<PathNode>();
    final HashSet<PathNode> closedSet = HashSet<PathNode>();

    openSet.add(
        PathNode(startGrid, 0, _calculateHeuristic(startGrid, endGrid), null));

    while (openSet.isNotEmpty) {
      // Get node with lowest f cost
      final PathNode current =
          openSet.reduce((PathNode a, PathNode b) => a.f < b.f ? a : b);

      // Check if we reached the end
      if ((current.position - endGrid).length < 0.1) {
        return _reconstructPath(current);
      }

      openSet.remove(current);
      closedSet.add(current);

      // Check all neighbors
      for (final PathNode neighbor in _getNeighbors(current)) {
        // Skip if already evaluated
        if (closedSet.contains(neighbor)) {
          continue;
        }

        final double tentativeG = current.g +
            _calculateMovementCost(current.position, neighbor.position);

        // Check if this path is better
        if (!openSet.contains(neighbor)) {
          openSet.add(PathNode(neighbor.position, tentativeG,
              _calculateHeuristic(neighbor.position, endGrid), current));
        } else {
          final PathNode? existingNode = openSet.lookup(neighbor);
          if (existingNode != null && tentativeG < existingNode.g) {
            openSet.remove(existingNode);
            openSet.add(PathNode(
                neighbor.position, tentativeG, existingNode.h, current));
          }
        }
      }
    }

    return <PathTile>[]; // No path found
  }

  double _calculateHeuristic(Vector2 start, Vector2 end) {
    // Manhattan distance
    return (end.x - start.x).abs() + (end.y - start.y).abs();
  }

  List<PathNode> _getNeighbors(PathNode node) {
    final List<PathNode> neighbors = <PathNode>[];
    final List<Vector2> directions = <Vector2>[
      Vector2(1, 0), // right
      Vector2(-1, 0), // left
      Vector2(0, 1), // down
      Vector2(0, -1), // up
    ];

    for (final Vector2 dir in directions) {
      final Vector2 newPos = node.position + dir;

      if (_isValidPosition(newPos)) {
        final MapTileType tileType =
            map[newPos.y.toInt() + yHalf][newPos.x.toInt() + xHalf].type;
        final double movementCost = terrainCosts[tileType] ?? double.infinity;

        // Skip unwalkable tiles
        if (movementCost == double.infinity) {
          continue;
        }

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
    final MapTileType fromType =
        map[from.y.toInt() + yHalf][from.x.toInt() + xHalf].type;
    final MapTileType toType =
        map[to.y.toInt() + yHalf][to.x.toInt() + xHalf].type;

    final double fromCost = terrainCosts[fromType] ?? double.infinity;
    final double toCost = terrainCosts[toType] ?? double.infinity;

    // Use average of both tiles' costs
    return straightCost * (fromCost + toCost) / 2;
  }

  List<PathTile> _reconstructPath(PathNode endNode) {
    final List<PathTile> path = <PathTile>[];
    PathNode current = endNode;

    while (current.parent != null) {
      path.add(PathTile(
          _gridToWorld(current.position),
          map[current.position.y.toInt() + yHalf]
                  [current.position.x.toInt() + xHalf]
              .type));
      current = current.parent!;
    }

    // Add start position
    path.add(PathTile(
        _gridToWorld(current.position),
        map[current.position.y.toInt() + yHalf]
                [current.position.x.toInt() + xHalf]
            .type));

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
