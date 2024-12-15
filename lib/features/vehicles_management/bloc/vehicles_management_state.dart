import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/vehicle.dart';

part 'vehicles_management_state.freezed.dart';

@freezed
class VehiclesManagmentState with _$VehiclesManagmentState {
  const factory VehiclesManagmentState({
    required List<Vehicle> boughtTrucks,
  }) = _VehiclesManagmentState;
}
