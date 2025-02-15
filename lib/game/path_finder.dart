// Node class for A* algorithm
import 'dart:collection';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../core/constants/game_constants.dart';
import '../data/enums/map_tile_type.dart';
import '../data/models/map_tile.dart';

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

  String get path =>
      '[${position.x.toInt()}, ${position.y.toInt()}] -> ${parent?.path}';

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
  final int xHalf = GameConstants.mapXHalf;
  final int yHalf = GameConstants.mapYHalf;

  final List<List<MapTile>> map;
  final double straightCost = 1.0;

  List<PathTile> findPath(List<Vector2> points) {
    if (points.isEmpty) {
      return [];
    }

    final List<PathTile> fullPath = [];

    for (int i = 0; i < points.length; i++) {
      final start = points[i];
      final end = i == points.length - 1 ? points[0] : points[i + 1];

      final pathSegment = _findPathSegment(start, end);
      if (pathSegment.isEmpty) {
        return []; // If any segment fails, return an empty path
      }

      fullPath.addAll(pathSegment);
    }

    return fullPath;
  }

  List<PathTile> _findPathSegment(Vector2 start, Vector2 end) {
    // Check if start or end is invalid
    if (!_isValidPosition(start) || !_isValidPosition(end)) {
      debugPrint('Invalid start or end position');
      return <PathTile>[];
    }

    final openSet = HashSet<PathNode>();
    final closedSet = HashSet<PathNode>();

    openSet.add(PathNode(start, 0, _calculateHeuristic(start, end), null));

    while (openSet.isNotEmpty) {
      // Get node with lowest f cost
      final current = openSet.reduce((a, b) => a.f < b.f ? a : b);

      // Check if we reached the end
      if ((current.position - end).length <= 1) {
        return _reconstructPath(current);
      }

      openSet.remove(current);
      closedSet.add(current);

      // Check all neighbors
      for (final PathNode neighbor in _getNeighbors(current)) {
        if (closedSet.contains(neighbor)) {
          continue;
        }

        final double tentativeG = current.g +
            _calculateMovementCost(current.position, neighbor.position);

        // Check if this path is better
        if (!openSet.contains(neighbor)) {
          openSet.add(PathNode(neighbor.position, tentativeG,
              _calculateHeuristic(neighbor.position, end), current));
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

    print('No path found');

    return <PathTile>[]; // No path found
  }

  double _calculateHeuristic(Vector2 start, Vector2 end) {
    // Manhattan distance
    return (end.x - start.x).abs() + (end.y - start.y).abs();
  }

  List<PathNode> _getNeighbors(PathNode node) {
    final List<PathNode> neighbors = <PathNode>[];
    final List<PathNode> roadAndCityNeighbors = <PathNode>[];
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
        final double movementCost = tileType.terrainCost;

        // Skip unwalkable tiles
        if (movementCost == double.infinity) {
          continue;
        }

        final PathNode neighbor = PathNode(
            newPos,
            0, // g cost will be calculated later
            0, // h cost will be calculated later
            node);

        if (tileType == MapTileType.road || tileType == MapTileType.city) {
          roadAndCityNeighbors.add(neighbor);
        } else {
          neighbors.add(neighbor);
        }
      }
    }

    // Prioritize road and city tiles
    if (roadAndCityNeighbors.isNotEmpty) {
      //TODO: Rewrite
      return roadAndCityNeighbors;
    }

    return neighbors;
  }

  bool _isValidPosition(Vector2 pos) {
    return pos.x >= -xHalf && pos.x < xHalf && pos.y >= -yHalf && pos.y < yHalf;
  }

  double _calculateMovementCost(Vector2 from, Vector2 to) {
    // Get terrain costs for both tiles
    final MapTile fromTile =
        map[from.y.toInt() + yHalf][from.x.toInt() + xHalf];
    final MapTile toTile = map[to.y.toInt() + yHalf][to.x.toInt() + xHalf];
    final MapTileType fromType = fromTile.type;
    final MapTileType toType = toTile.type;

    final double fromCost =
        fromTile.isUnlocked ? fromType.terrainCost : double.infinity;
    final double toCost =
        toTile.isUnlocked ? toType.terrainCost : double.infinity;

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

  Vector2 _gridToWorld(Vector2 gridPos) {
    return Vector2(
      gridPos.x * GameConstants.mapTileSize +
          (GameConstants.mapTileSize / 2), // Center of tile
      gridPos.y * GameConstants.mapTileSize + (GameConstants.mapTileSize / 2),
    );
  }
}
