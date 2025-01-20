import 'dart:ui';

import 'package:equatable/equatable.dart';

import '../../../data/enums/vehicle_status.dart';
import '../../../data/models/cargo.dart';
import '../../../data/models/market_vehicle.dart';

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
  final MarketVehicle vehicle;

  @override
  List<Object> get props => <Object>[vehicle];
}

class AssignVehicle extends VehiclesManagementEvent {
  const AssignVehicle({required this.vehicleId, required this.garageId});
  final String vehicleId;
  final String garageId;

  @override
  List<Object> get props => <Object>[vehicleId, garageId];
}

class UnassignVehicle extends VehiclesManagementEvent {
  const UnassignVehicle(this.vehicleId);
  final String vehicleId;

  @override
  List<Object> get props => <Object>[vehicleId];
}

class UpdateVehicleStatus extends VehiclesManagementEvent {
  const UpdateVehicleStatus(this.vehicleId, this.status);
  final String vehicleId;
  final VehicleStatus status;

  @override
  List<Object> get props => <Object>[vehicleId, status];
}

class RefillVehicle extends VehiclesManagementEvent {
  const RefillVehicle(
    this.vehicleId,
    this.fuel,
  );
  final String vehicleId;
  final double fuel;

  @override
  List<Object> get props => <Object>[vehicleId, fuel];
}

class VehicleFuelBurned extends VehiclesManagementEvent {
  const VehicleFuelBurned(
    this.vehicleId,
    this.fuel,
  );
  final String vehicleId;
  final double fuel;

  @override
  List<Object> get props => <Object>[vehicleId, fuel];
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
    required this.garageId,
  });
  final String vehicleId;
  final String garageId;
  final Cargo cargo;

  @override
  List<Object> get props => [vehicleId, cargo, garageId];
}

class RemoveCargoFromVehicle extends VehiclesManagementEvent {
  const RemoveCargoFromVehicle({
    required this.vehicleId,
    required this.cargo,
  });
  final String vehicleId;
  final Cargo cargo;

  @override
  List<Object> get props => [vehicleId, cargo];
}

class ClearVehicleCargo extends VehiclesManagementEvent {
  const ClearVehicleCargo({
    required this.vehicleId,
  });

  final String vehicleId;

  @override
  List<Object> get props => [vehicleId];
}
