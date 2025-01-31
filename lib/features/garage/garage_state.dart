import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/models/garage.dart';
import '../../data/models/map_tile_position.dart';

part 'garage_state.freezed.dart';
part 'garage_state.g.dart';

@freezed
class GarageState with _$GarageState {
  factory GarageState({
    @Default([]) List<Garage> garages,
    String? currentGarageId,
    String? selectedVehicleId,
    MapTilePosition? tileToBuildGarage,
  }) = _GarageState;
  const GarageState._();

  factory GarageState.fromJson(Map<String, dynamic> json) =>
      _$GarageStateFromJson(json);

  Garage? get currentGarage =>
      garages.firstWhereOrNull((Garage garage) => garage.id == currentGarageId);

  Garage? garageById(String? id) =>
      garages.firstWhereOrNull((Garage garage) => garage.id == id);
}
