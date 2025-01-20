import 'package:equatable/equatable.dart';

abstract class GameAlertEvent extends Equatable {
  const GameAlertEvent();

  @override
  List<Object> get props => <Object>[];
}

final class GameAlertGainCoins extends GameAlertEvent {
  const GameAlertGainCoins(this.amount);
  final int amount;

  @override
  List<Object> get props => <Object>[amount];
}

final class GameAlertTruckArrived extends GameAlertEvent {
  const GameAlertTruckArrived(this.name);
  final String name;

  @override
  List<Object> get props => <Object>[name];
}

final class GameAlertNoNeighbourTileDiscovered extends GameAlertEvent {
  const GameAlertNoNeighbourTileDiscovered();
}

final class GameAlertNoEnoughSpaceInVehicle extends GameAlertEvent {
  const GameAlertNoEnoughSpaceInVehicle();
}

final class GameAlertNoEnoughSpaceInGarage extends GameAlertEvent {
  const GameAlertNoEnoughSpaceInGarage();
}
