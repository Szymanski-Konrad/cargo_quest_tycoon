import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/map_tile_type.dart';
import 'map_tile_award.dart';
import 'map_tile_position.dart';

part 'map_tile.freezed.dart';
part 'map_tile.g.dart';

@freezed
class MapTile with _$MapTile {
  const factory MapTile({
    required MapTilePosition position,
    @Default(false) bool isUnlocked,
    required MapTileType type,
    @Default(false) bool hasGarage,
    MapTileAward? extraAward,
    // There can be some crates, vehicle parts, new truck to unlock etc.
    String? otherObject,
  }) = _MapTile;

  factory MapTile.fromJson(Map<String, dynamic> json) =>
      _$MapTileFromJson(json);
}
