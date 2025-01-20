import 'dart:ui';

import 'package:equatable/equatable.dart';

import '../../data/models/cargo.dart';
import '../../data/models/map_tile_position.dart';

sealed class GarageEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GaragesEventBuildNew extends GarageEvent {
  GaragesEventBuildNew({
    required this.garageName,
    required this.position,
  });
  final String garageName;
  final MapTilePosition position;

  @override
  List<Object?> get props => [garageName, position];
}

class GarageEventUpgrade extends GarageEvent {
  GarageEventUpgrade({required this.garageId});
  final String garageId;

  @override
  List<Object?> get props => [garageId];
}

class AssignVehicleToGarage extends GarageEvent {
  AssignVehicleToGarage({required this.garageId, required this.vehicleId});
  final String garageId;
  final String vehicleId;

  @override
  List<Object?> get props => [garageId, vehicleId];
}

class UnassignVehicle extends GarageEvent {
  UnassignVehicle({required this.vehicleId});
  final String vehicleId;

  @override
  List<Object?> get props => [vehicleId];
}

class ShowGarage extends GarageEvent {
  ShowGarage({
    required this.garagePosition,
    required this.onNoGarage,
  });
  final MapTilePosition garagePosition;
  final VoidCallback onNoGarage;

  @override
  List<Object?> get props => [garagePosition, onNoGarage];
}

class HideGarage extends GarageEvent {
  HideGarage();

  @override
  List<Object?> get props => [];
}

class ChangeVehicle extends GarageEvent {
  ChangeVehicle({required this.vehicleId});
  final String vehicleId;

  @override
  List<Object?> get props => [vehicleId];
}

class AddCargoToGarage extends GarageEvent {
  AddCargoToGarage({required this.garageId, required this.cargos});
  final String garageId;
  final List<Cargo> cargos;

  @override
  List<Object> get props => [garageId, cargos];
}

class RemoveCargoFromGarage extends GarageEvent {
  RemoveCargoFromGarage({required this.garageId, required this.cargoIds});
  final String garageId;
  final List<String> cargoIds;

  @override
  List<Object> get props => [garageId, cargoIds];
}
