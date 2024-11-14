import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_tile_award.freezed.dart';
part 'map_tile_award.g.dart';

// It can be some gold, crates, premium currency etc.
@freezed
class MapTileAward with _$MapTileAward {
  const factory MapTileAward({
    required String id,
    required String name,
    required int value,
  }) = _MapTileAward;

  factory MapTileAward.fromJson(Map<String, dynamic> json) =>
      _$MapTileAwardFromJson(json);
}
