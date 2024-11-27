import 'package:cargo_quest_tycoon/data/models/fuel_station.dart';
import 'package:cargo_quest_tycoon/data/models/map_tile_position.dart';
import 'package:cargo_quest_tycoon/features/fuel_stations/bloc/fuel_stations_event.dart';
import 'package:cargo_quest_tycoon/features/fuel_stations/bloc/fuel_stations_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FuelStationsBloc extends Bloc<FuelStationsEvent, FuelStationsState> {
  FuelStationsBloc()
      : super(
          FuelStationsState(
              primary: FuelStation(
            id: 'primary',
            name: 'Primary Fuel Station',
            location: MapTilePosition(x: 0, y: 0),
            fuelCapacity: 2000,
            currentFuelLevel: 1000,
            fuelRefillRate: 1,
            vehicleRefillRate: 1,
          )),
        ) {
    on<FuelStationsEventUpgrade>(_onUpgrade);
    on<FuelStationsEventRefillVehicle>(_onRefillVehicle);
    on<FuelStationsEventAddFuel>(_onAddFuel);
  }

  void _onUpgrade(
      FuelStationsEventUpgrade event, Emitter<FuelStationsState> emit) {
    emit(state.copyWith(
      primary: state.primary.copyWith(
        fuelCapacity: state.primary.fuelCapacity * 1.1,
        fuelRefillRate: state.primary.fuelRefillRate * 1.1,
        vehicleRefillRate: state.primary.vehicleRefillRate * 1.1,
      ),
    ));
  }

  void _onRefillVehicle(
      FuelStationsEventRefillVehicle event, Emitter<FuelStationsState> emit) {
    if (event.amount > state.primary.currentFuelLevel) {
      return;
    }
    emit(state.copyWith(
      primary: state.primary.copyWith(
        currentFuelLevel: state.primary.currentFuelLevel - event.amount,
      ),
    ));
  }

  void _onAddFuel(
      FuelStationsEventAddFuel event, Emitter<FuelStationsState> emit) {
    final leftCapacity =
        state.primary.fuelCapacity - state.primary.currentFuelLevel;
    final amount = leftCapacity < event.amount ? leftCapacity : event.amount;
    emit(state.copyWith(
      primary: state.primary.copyWith(
        currentFuelLevel: state.primary.currentFuelLevel + amount,
      ),
    ));
  }
}
