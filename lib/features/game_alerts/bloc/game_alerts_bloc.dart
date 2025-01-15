import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/game_alert_model.dart';
import '../models/game_alert_type.dart';
import 'game_alerts_event.dart';
import 'game_alerts_state.dart';

class GameAlertsBloc extends Bloc<GameAlertEvent, GameAlertsState> {
  GameAlertsBloc() : super(GameAlertsState()) {
    on<GameAlertGainCoins>(_onGainCoins);
    on<GameAlertTruckArrived>(_onTruckArrived);
    on<GameAlertNoNeighbourTileDiscovered>(_onNoNeighbourTileDiscovered);
  }

  void _onGainCoins(GameAlertGainCoins event, Emitter<GameAlertsState> emit) {
    emit(GameAlertsState(
      gameAlert: GameAlertModel(
        type: GameAlertType.gainCoins,
        message: 'You gained ${event.amount} coins!',
      ),
    ));
  }

  void _onTruckArrived(
      GameAlertTruckArrived event, Emitter<GameAlertsState> emit) {
    emit(GameAlertsState(
      gameAlert: GameAlertModel(
        type: GameAlertType.truckArrived,
        message: 'Truck ${event.name} has arrived!',
      ),
    ));
  }

  void _onNoNeighbourTileDiscovered(
      GameAlertNoNeighbourTileDiscovered event, Emitter<GameAlertsState> emit) {
    emit(GameAlertsState(
      gameAlert: GameAlertModel(
        type: GameAlertType.noNeighbourDiscovered,
        message: 'No connection to discovered tiles ${event.uuid}',
      ),
    ));
  }
}
