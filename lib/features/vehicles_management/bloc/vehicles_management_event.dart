import 'dart:ui';

import 'package:equatable/equatable.dart';

import '../../../data/models/cargo.dart';
import '../../../data/models/vehicle.dart';

abstract class VehiclesManagementEvent extends Equatable {
  const VehiclesManagementEvent();

  @override
  List<Object> get props => <Object>[];
}

class LoadVehicles extends VehiclesManagementEvent {}

class AddVehicle extends VehiclesManagementEvent {
  const AddVehicle(this.vehicleName);
  final String vehicleName;

  @override
  List<Object> get props => <Object>[vehicleName];
}

class BuyVehicle extends VehiclesManagementEvent {
  const BuyVehicle(this.vehicle);
  final Vehicle vehicle;

  @override
  List<Object> get props => <Object>[vehicle];
}

class UseVehicle extends VehiclesManagementEvent {
  const UseVehicle({required this.vehicleId, required this.cityId});
  final String vehicleId;
  final String cityId;

  @override
  List<Object> get props => <Object>[vehicleId, cityId];
}

class UpdateVehicle extends VehiclesManagementEvent {
  const UpdateVehicle(this.vehicleId, this.updatedName);
  final String vehicleId;
  final String updatedName;

  @override
  List<Object> get props => <Object>[vehicleId, updatedName];
}

class SellVehicle extends VehiclesManagementEvent {
  const SellVehicle(
    this.vehicleId,
    this.onVehicleSold,
  );
  final String vehicleId;
  final VoidCallback onVehicleSold;

  @override
  List<Object> get props => <Object>[vehicleId];
}

class AddCargoToVehicle extends VehiclesManagementEvent {
  const AddCargoToVehicle({
    required this.vehicleId,
    required this.cargo,
  });
  final String vehicleId;
  final Cargo cargo;

  @override
  List<Object> get props => [vehicleId, cargo];
}
