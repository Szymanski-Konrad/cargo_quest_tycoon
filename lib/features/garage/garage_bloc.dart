import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

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
      emit(state.copyWith(currentGarageId: garage.id));
    } else {
      emit(state.copyWith(tileToBuildGarage: event.garagePosition));
    }
  }

  void _onBuildNewGarage(
      GaragesEventBuildNew event, Emitter<GarageState> emit) {
    final Garage newGarage = Garage(
      id: const Uuid().v4(),
      slots: 5,
      storageLimit: 1000,
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
}
