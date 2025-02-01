import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/map_tile_type.dart';

part 'json_map_tile.freezed.dart';
part 'json_map_tile.g.dart';

@freezed
class JsonMapTile with _$JsonMapTile {
  factory JsonMapTile({
    required MapTileType type,
    required double x,
    required double y,
  }) = _JsonMapTile;

  factory JsonMapTile.fromJson(Map<String, dynamic> json) =>
      _$JsonMapTileFromJson(json);
}
