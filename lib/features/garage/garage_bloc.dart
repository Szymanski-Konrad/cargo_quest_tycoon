import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/cargo.dart';
import '../../data/models/garage.dart';
import 'garage_event.dart';
import 'garage_state.dart';

class GarageBloc extends Bloc<GarageEvent, GarageState> {
  GarageBloc() : super(GarageState()) {
    on<GaragesEventBuildNew>(_onBuildNewGarage);
    on<GarageEventUpgrade>(_onUpgradeGarage);
    on<AssignVehicleToGarage>(_onAssignVehicleToGarage);
    on<UnassignVehicle>(_onUnassignVehicle);
    on<ShowGarage>(_onShowGarage);
    on<ChangeVehicle>(_onChangeVehicle);
    on<AddCargoToGarage>(_onAddCargoToGarage);
    on<RemoveCargoFromGarage>(_onRemoveCargoFromGarage);
    on<AssignGarageCargoToVehicle>(_onAssignCargoToVehicle);
    on<UnassignGarageCargoFromVehicle>(_onUnassignCargoFromVehicle);
  }

  void _onChangeVehicle(ChangeVehicle event, Emitter<GarageState> emit) {
    emit(state.copyWith(selectedVehicleId: event.vehicleId));
  }

  void _onShowGarage(ShowGarage event, Emitter<GarageState> emit) {
    // Implement the logic for showing a garage
    final Garage? garage = state.garages.firstWhereOrNull(
      (Garage garage) => garage.position == event.garagePosition,
    );
    if (garage != null) {
      emit(state.copyWith(
        currentGarageId: garage.id,
        tileToBuildGarage: null,
      ));
    } else {
      event.onNoGarage.call();
      emit(state.copyWith(
        tileToBuildGarage: event.garagePosition,
        currentGarageId: null,
      ));
    }
  }

  void _onBuildNewGarage(
      GaragesEventBuildNew event, Emitter<GarageState> emit) {
    final Garage newGarage = Garage(
      id: const Uuid().v4(),
      slots: 5,
      storageLimit: 100,
      position: event.position,
      name: event.garageName,
    );
    final List<Garage> updatedGarages = List<Garage>.from(state.garages)
      ..add(newGarage);
    emit(state.copyWith(
      garages: updatedGarages,
      tileToBuildGarage: null,
      currentGarageId: newGarage.id,
    ));
  }

  void _onUpgradeGarage(GarageEventUpgrade event, Emitter<GarageState> emit) {
    // final updatedGarages = state.garages.map((garage) {
    //   if (garage.id == event.garageId) {
    //     return garage.copyWith(level: garage.level + 1);
    //   }
    //   return garage;
    // }).toList();
    // emit(state.copyWith(garages: updatedGarages));
  }

  void _onAssignVehicleToGarage(
      AssignVehicleToGarage event, Emitter<GarageState> emit) {
    final List<Garage> updatedGarages = state.garages.map((Garage garage) {
      if (garage.id == event.garageId) {
        final List<String> updatedVehicles = List<String>.from(garage.vehicles)
          ..add(event.vehicleId);
        return garage.copyWith(vehicles: updatedVehicles);
      }
      return garage;
    }).toList();
    emit(state.copyWith(garages: updatedGarages));
  }

  void _onUnassignVehicle(UnassignVehicle event, Emitter<GarageState> emit) {
    final List<Garage> updatedGarages = state.garages.map((Garage garage) {
      if (garage.vehicles.contains(event.vehicleId)) {
        final List<String> updatedVehicles = List<String>.from(garage.vehicles)
          ..remove(event.vehicleId);
        return garage.copyWith(vehicles: updatedVehicles);
      }
      return garage;
    }).toList();
    emit(state.copyWith(garages: updatedGarages));
  }

  void _onRemoveCargoFromGarage(
      RemoveCargoFromGarage event, Emitter<GarageState> emit) {
    final List<Garage> garages = List.of(state.garages);
    final int garageIndex = garages.indexWhere(
      (Garage garage) => garage.id == event.garageId,
    );
    if (garageIndex == -1) {
      return;
    }

    final List<Cargo> cargos = List.of(garages[garageIndex].cargos);
    cargos.removeWhere((element) => event.cargoIds.contains(element.id));
    final Garage garage = garages[garageIndex].copyWith(cargos: cargos);
    garages[garageIndex] = garage;
    emit(state.copyWith(garages: garages));
  }

  void _onAddCargoToGarage(AddCargoToGarage event, Emitter<GarageState> emit) {
    final List<Garage> garages = List.of(state.garages);
    final int garageIndex = garages.indexWhere(
      (Garage garage) => garage.id == event.garageId,
    );
    if (garageIndex == -1) {
      return;
    }

    final List<Cargo> cargos = List.of(garages[garageIndex].cargos);
    cargos.addAll(event.cargos);
    final Garage garage = garages[garageIndex].copyWith(cargos: cargos);
    garages[garageIndex] = garage;
    emit(state.copyWith(garages: garages));
  }

  FutureOr<void> _onAssignCargoToVehicle(
    AssignGarageCargoToVehicle event,
    Emitter<GarageState> emit,
  ) {
    _assignVehicleIdToCargo(
      garageId: event.garageId,
      vehicleId: event.vehicleId,
      cargoId: event.cargoId,
    );
  }

  FutureOr<void> _onUnassignCargoFromVehicle(
    UnassignGarageCargoFromVehicle event,
    Emitter<GarageState> emit,
  ) {
    _assignVehicleIdToCargo(
      garageId: event.garageId,
      vehicleId: null,
      cargoId: event.cargoId,
    );
  }

  void _assignVehicleIdToCargo({
    required String garageId,
    required String? vehicleId,
    required String cargoId,
  }) {
    final List<Garage> garages = List.of(state.garages);
    final int garageIndex =
        garages.indexWhere((Garage element) => element.id == garageId);
    if (garageIndex == -1) {
      return;
    }
    final List<Cargo> cargos = List.of(garages[garageIndex].cargos);
    final int cargoIndex =
        cargos.indexWhere((Cargo element) => element.id == cargoId);
    if (cargoIndex == -1) {
      return;
    }
    final Cargo cargo = cargos[cargoIndex].copyWith(vehicleId: vehicleId);
    cargos[cargoIndex] = cargo;
    final Garage garage = garages[garageIndex].copyWith(cargos: cargos);
    garages[garageIndex] = garage;
    emit(state.copyWith(garages: garages));
  }
}
