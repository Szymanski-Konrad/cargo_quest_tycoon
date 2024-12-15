import 'package:freezed_annotation/freezed_annotation.dart';

import 'cargo.dart';
import 'map_tile_position.dart';

part 'city.freezed.dart';
part 'city.g.dart';

@freezed
class City with _$City {
  factory City({
    required String id,
    required MapTilePosition position,
    required String name,
    @Default(0) int level,
    DateTime? nextRefreshTime,
    @Default(60) int refreshInterval,
    @Default(<Cargo>[]) List<Cargo> cargos,
  }) = _City;
  const City._();

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
}
