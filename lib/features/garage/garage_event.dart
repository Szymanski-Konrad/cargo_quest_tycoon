import 'dart:ui';

import 'package:equatable/equatable.dart';

import '../../data/models/cargo.dart';
import '../../data/models/map_tile_position.dart';

sealed class GarageEvent extends Equatable {
  const GarageEvent();

  @override
  List<Object?> get props => [];
}

class GaragesEventBuildNew extends GarageEvent {
  const GaragesEventBuildNew({
    required this.garageName,
    required this.position,
  });
  final String garageName;
  final MapTilePosition position;

  @override
  List<Object?> get props => [garageName, position];
}

class GarageEventUpgrade extends GarageEvent {
  const GarageEventUpgrade({required this.garageId});
  final String garageId;

  @override
  List<Object?> get props => [garageId];
}

class AssignVehicleToGarage extends GarageEvent {
  const AssignVehicleToGarage(
      {required this.garageId, required this.vehicleId});
  final String garageId;
  final String vehicleId;

  @override
  List<Object?> get props => [garageId, vehicleId];
}

class UnassignVehicle extends GarageEvent {
  const UnassignVehicle({required this.vehicleId});
  final String vehicleId;

  @override
  List<Object?> get props => [vehicleId];
}

class ShowGarage extends GarageEvent {
  const ShowGarage({
    required this.garagePosition,
    required this.onNoGarage,
  });
  final MapTilePosition garagePosition;
  final VoidCallback onNoGarage;

  @override
  List<Object?> get props => [garagePosition, onNoGarage];
}

class HideGarage extends GarageEvent {
  const HideGarage();
}

class ChangeVehicle extends GarageEvent {
  const ChangeVehicle({required this.vehicleId});
  final String vehicleId;

  @override
  List<Object?> get props => [vehicleId];
}

class AddCargoToGarage extends GarageEvent {
  const AddCargoToGarage({required this.garageId, required this.cargos});
  final String garageId;
  final List<Cargo> cargos;

  @override
  List<Object> get props => [garageId, cargos];
}

class RemoveCargoFromGarage extends GarageEvent {
  const RemoveCargoFromGarage({required this.garageId, required this.cargoIds});
  final String garageId;
  final List<String> cargoIds;

  @override
  List<Object> get props => [garageId, cargoIds];
}

class AssignGarageCargoToVehicle extends GarageEvent {
  const AssignGarageCargoToVehicle({
    required this.garageId,
    required this.cargoId,
    required this.vehicleId,
  });
  final String garageId;
  final String cargoId;
  final String vehicleId;

  @override
  List<Object> get props => [garageId, cargoId, vehicleId];
}

class UnassignGarageCargoFromVehicle extends GarageEvent {
  const UnassignGarageCargoFromVehicle(
      {required this.garageId, required this.cargoId});
  final String garageId;
  final String cargoId;

  @override
  List<Object> get props => [garageId, cargoId];
}
