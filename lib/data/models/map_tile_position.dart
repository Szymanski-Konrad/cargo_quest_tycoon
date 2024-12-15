import 'package:flame/components.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_tile_position.freezed.dart';
part 'map_tile_position.g.dart';

@freezed
class MapTilePosition with _$MapTilePosition {
  factory MapTilePosition({
    required double x,
    required double y,
  }) = _MapTilePosition;

  factory MapTilePosition.fromJson(Map<String, dynamic> json) =>
      _$MapTilePositionFromJson(json);
}

extension MapTilePositionExtension on MapTilePosition {
  ({double x, double y}) toTuple() => (x: x, y: y);

  bool isGridEqual(Vector2 gridPosition) =>
      x == gridPosition.x && y == gridPosition.y;
}
