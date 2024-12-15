import 'package:equatable/equatable.dart';

import '../../data/models/cargo.dart';

sealed class GarageEvent extends Equatable {
  @override
  List<Object?> get props => <Object?>[];
}

class GaragesEventBuildNew extends GarageEvent {
  GaragesEventBuildNew({required this.cityId});
  final String cityId;

  @override
  List<Object?> get props => <Object?>[cityId];
}

class GarageEventUpgrade extends GarageEvent {
  GarageEventUpgrade({required this.garageId});
  final String garageId;

  @override
  List<Object?> get props => <Object?>[garageId];
}

class AssignVehicleToGarage extends GarageEvent {
  AssignVehicleToGarage({required this.garageId, required this.vehicleId});
  final String garageId;
  final String vehicleId;

  @override
  List<Object?> get props => <Object?>[garageId, vehicleId];
}

class UnassignVehicle extends GarageEvent {
  UnassignVehicle({required this.vehicleId});
  final String vehicleId;

  @override
  List<Object?> get props => <Object?>[vehicleId];
}

class ShowGarage extends GarageEvent {
  ShowGarage({required this.garageId});
  final String garageId;

  @override
  List<Object?> get props => <Object?>[garageId];
}

class HideGarage extends GarageEvent {
  HideGarage();

  @override
  List<Object?> get props => <Object?>[];
}

class ChangeVehicle extends GarageEvent {
  ChangeVehicle({required this.vehicleId});
  final String vehicleId;

  @override
  List<Object?> get props => [vehicleId];
}
