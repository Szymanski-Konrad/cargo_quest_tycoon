import 'package:cargo_quest_tycoon/data/models/vehicle.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'vehicles_management_state.freezed.dart';

@freezed
class VehiclesManagmentState with _$VehiclesManagmentState {
  const factory VehiclesManagmentState({
    required List<Vehicle> boughtTrucks,
    required List<Vehicle> usedCars,
  }) = _VehiclesManagmentState;
}
