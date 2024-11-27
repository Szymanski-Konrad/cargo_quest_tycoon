import 'package:cargo_quest_tycoon/data/models/vehicle.dart';
import 'package:cargo_quest_tycoon/features/vehicles_management/bloc/vehicles_management_event.dart';
import 'package:cargo_quest_tycoon/features/vehicles_management/bloc/vehicles_management_state.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehiclesManagementBloc
    extends Bloc<VehiclesManagementEvent, VehiclesManagmentState> {
  VehiclesManagementBloc()
      : super(
          const VehiclesManagmentState(
            boughtTrucks: [],
            usedCars: [],
          ),
        ) {
    on<BuyVehicle>(_onBuyVehicle);
    on<SellVehicle>(_onSellVehicle);
    on<UseVehicle>(_onUseVehicle);
  }

  void _onBuyVehicle(BuyVehicle event, Emitter<VehiclesManagmentState> emit) {
    // Implement the logic for buying a vehicle here
  }

  void _onSellVehicle(SellVehicle event, Emitter<VehiclesManagmentState> emit) {
    final bought = List.of(state.boughtTrucks);
    final used = List.of(state.usedCars);
    Vehicle? vehicle = bought.firstWhereOrNull(
      (element) => element.id == event.vehicleId,
    );

    vehicle ??= used.firstWhereOrNull(
      (element) => element.id == event.vehicleId,
    );

    if (vehicle == null) {
      return;
    }

    if (bought.contains(vehicle)) {
      bought.remove(vehicle);
    } else {
      used.remove(vehicle);
    }

    event.onVehicleSold();
  }

  void _onUseVehicle(UseVehicle event, Emitter<VehiclesManagmentState> emit) {
    final bought = List.of(state.boughtTrucks);
    final used = List.of(state.usedCars);
    final vehicle = bought.firstWhere(
      (element) => element.id == event.vehicleId,
    );
    bought.remove(vehicle);
    used.add(vehicle);
    emit(state.copyWith(
      usedCars: used,
      boughtTrucks: bought,
    ));
  }
}
