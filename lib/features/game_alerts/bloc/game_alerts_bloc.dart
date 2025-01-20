import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../models/game_alert_model.dart';
import '../models/game_alert_type.dart';
import 'game_alerts_event.dart';
import 'game_alerts_state.dart';

class GameAlertsBloc extends Bloc<GameAlertEvent, GameAlertsState> {
  GameAlertsBloc() : super(GameAlertsState()) {
    on<GameAlertGainCoins>(_onGainCoins);
    on<GameAlertTruckArrived>(_onTruckArrived);
    on<GameAlertNoNeighbourTileDiscovered>(_onNoNeighbourTileDiscovered);
    on<GameAlertNoEnoughSpaceInGarage>(_onNoEnoughSpaceInGarage);
    on<GameAlertNoEnoughSpaceInVehicle>(_onNoEnoughSpaceInVehicle);
  }

  void _onGainCoins(GameAlertGainCoins event, Emitter<GameAlertsState> emit) {
    emit(GameAlertsState(
      gameAlert: GameAlertModel(
        type: GameAlertType.gainCoins,
        uuid: const Uuid().v4(),
        message: 'You gained ${event.amount} coins!',
      ),
    ));
  }

  void _onTruckArrived(
      GameAlertTruckArrived event, Emitter<GameAlertsState> emit) {
    emit(GameAlertsState(
      gameAlert: GameAlertModel(
        type: GameAlertType.truckArrived,
        uuid: const Uuid().v4(),
        message: 'Truck ${event.name} has arrived!',
      ),
    ));
  }

  void _onNoNeighbourTileDiscovered(
      GameAlertNoNeighbourTileDiscovered event, Emitter<GameAlertsState> emit) {
    emit(GameAlertsState(
      gameAlert: GameAlertModel(
        type: GameAlertType.noNeighbourDiscovered,
        uuid: const Uuid().v4(),
        message: 'No connection to discovered tiles',
      ),
    ));
  }

  FutureOr<void> _onNoEnoughSpaceInGarage(
      GameAlertNoEnoughSpaceInGarage event, Emitter<GameAlertsState> emit) {
    emit(GameAlertsState(
      gameAlert: GameAlertModel(
        type: GameAlertType.noEnoughSpaceInGarage,
        uuid: const Uuid().v4(),
        message: 'Not enough space in garage',
      ),
    ));
  }

  FutureOr<void> _onNoEnoughSpaceInVehicle(
      GameAlertNoEnoughSpaceInVehicle event, Emitter<GameAlertsState> emit) {
    emit(GameAlertsState(
      gameAlert: GameAlertModel(
        type: GameAlertType.noEnoughSpaceInVehicle,
        uuid: const Uuid().v4(),
        message: 'Vehicle has not enough space',
      ),
    ));
  }
}
