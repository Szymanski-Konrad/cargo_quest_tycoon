import 'package:cargo_quest_tycoon/data/models/map_tile_position.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fuel_station.freezed.dart';
part 'fuel_station.g.dart';

@freezed
class FuelStation with _$FuelStation {
  const FuelStation._();

  const factory FuelStation({
    required String id,
    required String name,
    required MapTilePosition location,
    required double fuelCapacity,
    required double currentFuelLevel,
    required double fuelRefillRate,
    required double vehicleRefillRate,
  }) = _FuelStation;

  factory FuelStation.fromJson(Map<String, dynamic> json) =>
      _$FuelStationFromJson(json);
}
