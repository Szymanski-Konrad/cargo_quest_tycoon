import 'package:cargo_quest_tycoon/data/models/fuel_station.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fuel_stations_state.freezed.dart';
part 'fuel_stations_state.g.dart';

@freezed
class FuelStationsState with _$FuelStationsState {
  factory FuelStationsState({
    required FuelStation primary,
  }) = _FuelStationsState;

  factory FuelStationsState.fromJson(Map<String, dynamic> json) =>
      _$FuelStationsStateFromJson(json);
}
