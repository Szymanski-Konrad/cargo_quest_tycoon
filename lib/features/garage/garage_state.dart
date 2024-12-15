import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/models/garage.dart';
import '../../data/models/vehicle.dart';

part 'garage_state.freezed.dart';
part 'garage_state.g.dart';

@freezed
class GarageState with _$GarageState {
  factory GarageState({
    @Default([]) List<Garage> garages,
    String? currentGarageId,
    String? selectedVehicleId,
  }) = _GarageState;
  const GarageState._();

  factory GarageState.fromJson(Map<String, dynamic> json) =>
      _$GarageStateFromJson(json);

  Garage? getGarageByCity(String? cityId) =>
      garages.firstWhereOrNull((Garage garage) => garage.cityId == cityId);

  bool isGarageInCity(String? cityId) {
    if (cityId == null) {
      return false;
    }
    return garages.any((Garage garage) => garage.cityId == cityId);
  }

  Garage? get currentGarage =>
      garages.firstWhereOrNull((Garage garage) => garage.id == currentGarageId);
}
