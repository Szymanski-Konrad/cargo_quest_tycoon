import 'dart:collection';

import 'package:flame/components.dart';

import '../core/constants/game_constants.dart';
import '../data/enums/map_tile_type.dart';
import '../data/models/map_tile.dart';
import 'path_finder.dart';

class TwoPhasePathFinder {
  TwoPhasePathFinder(this.map);
  final int xHalf = GameConstants.mapXHalf;
  final int yHalf = GameConstants.mapYHalf;
  final List<List<MapTile>> map;
  final double straightCost = 1.0;

  List<PathTile> findPath(List<Vector2> points) {
    if (points.length < 2) return [];

    final List<PathTile> fullPath = [];

    for (int i = 0; i < points.length; i++) {
      final start = points[i];
      final end = i == points.length - 1 ? points[0] : points[i + 1];

      // Try roads/cities first
      final segmentPath = _findPathWithFilter(
        start,
        end,
        (MapTileType type) =>
            type == MapTileType.road || type == MapTileType.city,
      );

      if (segmentPath.isNotEmpty) {
        fullPath.addAll(segmentPath);
        continue;
      }

      // If roads-only fails, try hybrid path
      final hybridPath = _findHybridPath(start, end);
      if (hybridPath.isEmpty)
        return []; // If any segment fails, return empty path

      fullPath.addAll(hybridPath);
    }

    return fullPath;
  }

  List<PathTile> _findPathWithFilter(
    Vector2 start,
    Vector2 end,
    bool Function(MapTileType) tileFilter,
  ) {
    if (!_isValidPosition(start) || !_isValidPosition(end)) {
      return [];
    }

    final openSet = HashSet<PathNode>();
    final closedSet = HashSet<PathNode>();
    openSet.add(PathNode(start, 0, _calculateHeuristic(start, end), null));

    while (openSet.isNotEmpty) {
      final current = openSet.reduce((a, b) => a.f < b.f ? a : b);

      if ((current.position - end).length <= 1) {
        return _reconstructPath(current);
      }

      openSet.remove(current);
      closedSet.add(current);

      for (final neighbor in _getFilteredNeighbors(current, tileFilter)) {
        if (closedSet.contains(neighbor)) continue;

        final tentativeG = current.g +
            _calculateMovementCost(current.position, neighbor.position);

        if (!openSet.contains(neighbor)) {
          openSet.add(PathNode(neighbor.position, tentativeG,
              _calculateHeuristic(neighbor.position, end), current));
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
    return [];
  }

  List<PathTile> _findHybridPath(Vector2 start, Vector2 end) {
    final openSet = HashSet<PathNode>();
    final closedSet = HashSet<PathNode>();
    openSet.add(PathNode(start, 0, _calculateHeuristic(start, end), null));

    while (openSet.isNotEmpty) {
      final current = openSet.reduce((a, b) => a.f < b.f ? a : b);

      if ((current.position - end).length <= 1) {
        return _reconstructPath(current);
      }

      openSet.remove(current);
      closedSet.add(current);

      for (final neighbor in _getAllNeighbors(current)) {
        if (closedSet.contains(neighbor)) continue;

        final MapTileType neighborType = _getTileType(neighbor.position);
        double costMultiplier = 1.0;

        if (neighborType != MapTileType.road &&
            neighborType != MapTileType.city) {
          costMultiplier = 10.0;
        }

        final tentativeG = current.g +
            _calculateMovementCost(current.position, neighbor.position) *
                costMultiplier;

        if (!openSet.contains(neighbor)) {
          openSet.add(PathNode(neighbor.position, tentativeG,
              _calculateHeuristic(neighbor.position, end), current));
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
    return [];
  }

  List<PathNode> _getFilteredNeighbors(
    PathNode node,
    bool Function(MapTileType) tileFilter,
  ) {
    final neighbors = <PathNode>[];
    final directions = <Vector2>[
      Vector2(1, 0),
      Vector2(-1, 0),
      Vector2(0, 1),
      Vector2(0, -1),
    ];

    for (final dir in directions) {
      final newPos = node.position + dir;
      if (_isValidPosition(newPos)) {
        final tileType = _getTileType(newPos);
        if (tileFilter(tileType) && tileType.terrainCost != double.infinity) {
          neighbors.add(PathNode(newPos, 0, 0, node));
        }
      }
    }
    return neighbors;
  }

  List<PathNode> _getAllNeighbors(PathNode node) {
    return _getFilteredNeighbors(node, (type) => type.isDrivable);
  }

  MapTileType _getTileType(Vector2 pos) {
    return map[pos.y.toInt() + yHalf][pos.x.toInt() + xHalf].type;
  }

  bool _isValidPosition(Vector2 pos) =>
      pos.x >= -xHalf && pos.x < xHalf && pos.y >= -yHalf && pos.y < yHalf;

  double _calculateHeuristic(Vector2 start, Vector2 end) =>
      (end.x - start.x).abs() + (end.y - start.y).abs();

  double _calculateMovementCost(Vector2 from, Vector2 to) {
    final fromTile = map[from.y.toInt() + yHalf][from.x.toInt() + xHalf];
    final toTile = map[to.y.toInt() + yHalf][to.x.toInt() + xHalf];

    final fromCost =
        fromTile.isUnlocked ? fromTile.type.terrainCost : double.infinity;
    final toCost =
        toTile.isUnlocked ? toTile.type.terrainCost : double.infinity;

    return straightCost * (fromCost + toCost) / 2;
  }

  List<PathTile> _reconstructPath(PathNode endNode) {
    final path = <PathTile>[];
    var current = endNode;

    while (current.parent != null) {
      path.add(PathTile(
        _gridToWorld(current.position),
        _getTileType(current.position),
      ));
      current = current.parent!;
    }

    path.add(PathTile(
      _gridToWorld(current.position),
      _getTileType(current.position),
    ));

    return path.reversed.toList();
  }

  Vector2 _gridToWorld(Vector2 gridPos) {
    return Vector2(
      gridPos.x * GameConstants.mapTileSize + (GameConstants.mapTileSize / 2),
      gridPos.y * GameConstants.mapTileSize + (GameConstants.mapTileSize / 2),
    );
  }
}
