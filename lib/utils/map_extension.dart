import '../data/enums/map_tile_type.dart';
import '../data/models/map_tile.dart';
import '../data/models/map_tile_position.dart';

extension MapExtension on List<List<MapTile>> {
  ({double x, double y}) get translation {
    return this[0][0].position.toTuple();
  }

  void discoverTile(MapTilePosition position) {
    final int x = (position.x - translation.x).toInt();
    final int y = (position.y - translation.y).toInt();
    final MapTile item = this[y][x];
    this[y][x] = item.copyWith(isUnlocked: true);
  }

  /// y positions size
  int get height => length - 1;

  /// x positions size
  int get width => this[0].length - 1;

  bool isRightNeigbourDiscovered(MapTilePosition position,
      {MapTileType? optionalType}) {
    final int x = (position.x - translation.x).toInt();
    final int y = (position.y - translation.y).toInt();

    if (x >= width - 1) {
      return false;
    }

    final MapTile item = this[y][x + 1];
    if (optionalType != null) {
      return item.isUnlocked && item.type == optionalType;
    }
    return item.isUnlocked;
  }

  bool isLeftNeigbourDiscovered(MapTilePosition position,
      {MapTileType? optionalType}) {
    final int x = (position.x - translation.x).toInt();
    final int y = (position.y - translation.y).toInt();
    if (x <= 0) {
      return false;
    }
    final MapTile item = this[y][x - 1];
    if (optionalType != null) {
      return item.isUnlocked && item.type == optionalType;
    }
    return item.isUnlocked;
  }

  bool isTopNeigbourDiscovered(MapTilePosition position,
      {MapTileType? optionalType}) {
    final int x = (position.x - translation.x).toInt();
    final int y = (position.y - translation.y).toInt();
    if (y <= 0) {
      return false;
    }
    final MapTile item = this[y - 1][x];
    if (optionalType != null) {
      return item.isUnlocked && item.type == optionalType;
    }
    return item.isUnlocked;
  }

  bool isBottomNeigbourDiscovered(MapTilePosition position,
      {MapTileType? optionalType}) {
    final int x = (position.x - translation.x).toInt();
    final int y = (position.y - translation.y).toInt();
    if (y > height - 1) {
      return false;
    }
    final MapTile item = this[y + 1][x];
    if (optionalType != null) {
      return item.isUnlocked && item.type == optionalType;
    }
    return item.isUnlocked;
  }

  bool isRoadNearby(MapTilePosition position) =>
      isRightNeigbourDiscovered(position, optionalType: MapTileType.road) ||
      isLeftNeigbourDiscovered(position, optionalType: MapTileType.road) ||
      isTopNeigbourDiscovered(position, optionalType: MapTileType.road) ||
      isBottomNeigbourDiscovered(position, optionalType: MapTileType.road);

  bool isAnyNeighborDiscovered(MapTilePosition position) =>
      isRightNeigbourDiscovered(position) ||
      isLeftNeigbourDiscovered(position) ||
      isTopNeigbourDiscovered(position) ||
      isBottomNeigbourDiscovered(position);
}
