import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

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
    on<UseVehicle>(_onUseVehicle);
    on<AddCargoToVehicle>(_onAddCargoToVehicle);
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

  void _onBuyVehicle(BuyVehicle event, Emitter<VehiclesManagmentState> emit) {
    final List<Vehicle> bought = List.of(state.boughtTrucks);
    bought.add(event.vehicle.copyWith(id: const Uuid().v4()));
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

  void _onUseVehicle(UseVehicle event, Emitter<VehiclesManagmentState> emit) {
    final List<Vehicle> bought = List.of(state.boughtTrucks);
    Vehicle vehicle = bought.firstWhere(
      (Vehicle element) => element.id == event.vehicleId,
    );
    vehicle = vehicle.copyWith(cityAssignedId: event.cityId);
  }
}
