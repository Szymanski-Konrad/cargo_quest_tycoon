import 'dart:ui';

import 'package:cargo_quest_tycoon/data/models/vehicle.dart';
import 'package:equatable/equatable.dart';

abstract class VehiclesManagementEvent extends Equatable {
  const VehiclesManagementEvent();

  @override
  List<Object> get props => [];
}

class LoadVehicles extends VehiclesManagementEvent {}

class AddVehicle extends VehiclesManagementEvent {
  final String vehicleName;

  const AddVehicle(this.vehicleName);

  @override
  List<Object> get props => [vehicleName];
}

class BuyVehicle extends VehiclesManagementEvent {
  final Vehicle vehicle;

  const BuyVehicle(this.vehicle);

  @override
  List<Object> get props => [vehicle];
}

class UseVehicle extends VehiclesManagementEvent {
  final String vehicleId;

  const UseVehicle(this.vehicleId);

  @override
  List<Object> get props => [vehicleId];
}

class UpdateVehicle extends VehiclesManagementEvent {
  final String vehicleId;
  final String updatedName;

  const UpdateVehicle(this.vehicleId, this.updatedName);

  @override
  List<Object> get props => [vehicleId, updatedName];
}

class SellVehicle extends VehiclesManagementEvent {
  final String vehicleId;
  final VoidCallback onVehicleSold;

  const SellVehicle(
    this.vehicleId,
    this.onVehicleSold,
  );

  @override
  List<Object> get props => [vehicleId];
}
