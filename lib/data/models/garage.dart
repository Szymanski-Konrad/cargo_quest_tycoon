import 'package:freezed_annotation/freezed_annotation.dart';

import 'cargo.dart';
import 'map_tile_position.dart';

part 'garage.freezed.dart';
part 'garage.g.dart';

@freezed
class Garage with _$Garage {
  const factory Garage({
    required String id,
    required MapTilePosition position,
    required String name,
    required int slots,
    @Default(<String>[]) List<String> vehicles,
    @Default(<Cargo>[]) List<Cargo> cargos,
    required double storageLimit,
  }) = _Garage;

  factory Garage.fromJson(Map<String, dynamic> json) => _$GarageFromJson(json);
}
