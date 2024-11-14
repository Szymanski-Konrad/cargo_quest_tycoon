import 'package:cargo_quest_tycoon/data/enums/map_tile_type.dart';
import 'package:cargo_quest_tycoon/data/models/map_tile_award.dart';
import 'package:cargo_quest_tycoon/data/models/map_tile_position.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_tile.freezed.dart';
part 'map_tile.g.dart';

@freezed
class MapTile with _$MapTile {
  const factory MapTile({
    required MapTilePosition position,
    required bool isUnlocked,
    required MapTileType type,
    MapTileAward? extraAward,
    // There can be some crates, vehicle parts, new truck to unlock etc.
    String? otherObject,
  }) = _MapTile;

  factory MapTile.fromJson(Map<String, dynamic> json) =>
      _$MapTileFromJson(json);
}
