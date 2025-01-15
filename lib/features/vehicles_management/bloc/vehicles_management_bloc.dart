import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/cargo.dart';
import '../../../data/models/vehicle.dart';
import 'vehicles_management_event.dart';
import 'vehicles_management_state.dart';

class VehiclesManagementBloc
    extends Bloc<VehiclesManagementEvent, VehiclesManagmentState> {
  VehiclesManagementBloc()
      : super(
          const VehiclesManagmentState(
            boughtTrucks: <Vehicle>[],
          ),
        ) {
    on<BuyVehicle>(_onBuyVehicle);
    on<SellVehicle>(_onSellVehicle);
    on<AssignVehicle>(_onAssignVehicle);
    on<UnassignVehicle>(_onUnassignVehicle);
    on<AddCargoToVehicle>(_onAddCargoToVehicle);
    on<RemoveCargoFromVehicle>(_onRemoveCargoFromVehicle);
    on<UpdateVehicleStatus>(_onUpdateVehicleStatus);
    on<ClearVehicleCargo>(_onClearVehicleCargo);
    on<RefillVehicle>(_onRefillVehicle);
    on<VehicleFuelBurned>(_onVehicleFuelBurned);
  }

  void _onVehicleFuelBurned(
      VehicleFuelBurned event, Emitter<VehiclesManagmentState> emit) {
    final vehicle = state.boughtTrucks.firstWhereOrNull(
      (Vehicle vehicle) => vehicle.id == event.vehicleId,
    );

    if (vehicle != null) {
      final updatedVehicle = vehicle.copyWith(
          currentFuelLevel: vehicle.currentFuelLevel - event.fuel);
      final vehicles = List.of(state.boughtTrucks)
        ..remove(vehicle)
        ..add(updatedVehicle);
      emit(state.copyWith(boughtTrucks: vehicles));
    }
  }

  void _onRefillVehicle(
      RefillVehicle event, Emitter<VehiclesManagmentState> emit) {
    final vehicle = state.boughtTrucks.firstWhereOrNull(
      (Vehicle vehicle) => vehicle.id == event.vehicleId,
    );

    if (vehicle != null && vehicle.currentFuelLevel <= vehicle.fuelCapacity) {
      final updatedVehicle = vehicle.copyWith(
          currentFuelLevel: vehicle.currentFuelLevel + event.fuel);
      final vehicles = List.of(state.boughtTrucks)
        ..remove(vehicle)
        ..add(updatedVehicle);
      emit(state.copyWith(boughtTrucks: vehicles));
    }
  }

  void _onClearVehicleCargo(
      ClearVehicleCargo event, Emitter<VehiclesManagmentState> emit) {
    final vehicle = state.boughtTrucks.firstWhereOrNull(
      (Vehicle vehicle) => vehicle.id == event.vehicleId,
    );

    if (vehicle != null) {
      final updatedVehicle = vehicle.copyWith(cargos: []);
      final vehicles = List.of(state.boughtTrucks)
        ..remove(vehicle)
        ..add(updatedVehicle);
      emit(state.copyWith(boughtTrucks: vehicles));
    }
  }

  void _onUpdateVehicleStatus(
    UpdateVehicleStatus event,
    Emitter<VehiclesManagmentState> emit,
  ) {
    final vehicle = state.boughtTrucks.firstWhereOrNull(
      (Vehicle vehicle) => vehicle.id == event.vehicleId,
    );

    if (vehicle != null) {
      final updatedVehicle = vehicle.copyWith(status: event.status);
      final vehicles = List.of(state.boughtTrucks)
        ..remove(vehicle)
        ..add(updatedVehicle);
      emit(state.copyWith(boughtTrucks: vehicles));
    }
  }

  void _onAddCargoToVehicle(
      AddCargoToVehicle event, Emitter<VehiclesManagmentState> emit) {
    final vehicle = state.boughtTrucks.firstWhereOrNull(
      (Vehicle vehicle) => vehicle.id == event.vehicleId,
    );

    if (vehicle != null) {
      final List<Cargo> updatedCargo = List<Cargo>.from(vehicle.cargos)
        ..add(event.cargo);
      final updatedVehicle = vehicle.copyWith(cargos: updatedCargo);
      final vehicles = List.of(state.boughtTrucks)
        ..remove(vehicle)
        ..add(updatedVehicle);
      emit(state.copyWith(boughtTrucks: vehicles));
    }
  }

  void _onRemoveCargoFromVehicle(
      RemoveCargoFromVehicle event, Emitter<VehiclesManagmentState> emit) {
    final vehicle = state.boughtTrucks.firstWhereOrNull(
      (Vehicle vehicle) => vehicle.id == event.vehicleId,
    );

    if (vehicle != null) {
      final List<Cargo> updatedCargo = List<Cargo>.from(vehicle.cargos);
      updatedCargo.removeWhere((item) => item.id == event.cargo.id);
      final updatedVehicle = vehicle.copyWith(cargos: updatedCargo);
      final vehicles = List.of(state.boughtTrucks)
        ..remove(vehicle)
        ..add(updatedVehicle);
      emit(state.copyWith(boughtTrucks: vehicles));
    }
  }

  void _onBuyVehicle(BuyVehicle event, Emitter<VehiclesManagmentState> emit) {
    final List<Vehicle> bought = List.of(state.boughtTrucks);
    bought.add(Vehicle.fromMarketVehicle(event.vehicle));
    emit(state.copyWith(boughtTrucks: bought));
  }

  void _onSellVehicle(SellVehicle event, Emitter<VehiclesManagmentState> emit) {
    final List<Vehicle> bought = List.of(state.boughtTrucks);
    final Vehicle? vehicle = bought.firstWhereOrNull(
      (Vehicle element) => element.id == event.vehicleId,
    );

    if (vehicle == null) {
      return;
    }
    bought.remove(vehicle);

    event.onVehicleSold();
  }

  void _onAssignVehicle(
      AssignVehicle event, Emitter<VehiclesManagmentState> emit) {
    final List<Vehicle> bought = List.of(state.boughtTrucks);
    Vehicle vehicle = bought.firstWhere(
      (Vehicle element) => element.id == event.vehicleId,
    );
    final index = bought.indexOf(vehicle);
    vehicle = vehicle.copyWith(garageId: event.garageId);
    bought.replaceRange(index, index + 1, [vehicle]);
    emit(state.copyWith(boughtTrucks: bought));
  }

  void _onUnassignVehicle(
      UnassignVehicle event, Emitter<VehiclesManagmentState> emit) {
    final List<Vehicle> bought = List.of(state.boughtTrucks);
    Vehicle vehicle = bought.firstWhere(
      (Vehicle element) => element.id == event.vehicleId,
    );
    final index = bought.indexOf(vehicle);
    vehicle = vehicle.copyWith(garageId: null);
    bought.replaceRange(index, index + 1, [vehicle]);
    emit(state.copyWith(boughtTrucks: bought));
  }
}
