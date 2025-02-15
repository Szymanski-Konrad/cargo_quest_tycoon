import 'package:equatable/equatable.dart';

abstract class GameAlertEvent extends Equatable {
  const GameAlertEvent();

  @override
  List<Object> get props => [];
}

final class GameAlertGainCoins extends GameAlertEvent {
  const GameAlertGainCoins(this.amount);
  final int amount;

  @override
  List<Object> get props => [amount];
}

final class GameAlertSpendCoins extends GameAlertEvent {
  const GameAlertSpendCoins(this.amount);
  final int amount;

  @override
  List<Object> get props => [amount];
}

final class GameAlertTruckArrived extends GameAlertEvent {
  const GameAlertTruckArrived(this.name);
  final String name;

  @override
  List<Object> get props => [name];
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

final class GameAlertNotEnoughFuel extends GameAlertEvent {
  const GameAlertNotEnoughFuel(this.fuelNeeded);
  final double fuelNeeded;

  @override
  List<Object> get props => [fuelNeeded];
}

final class GameAlertGainExp extends GameAlertEvent {
  const GameAlertGainExp(this.exp);
  final int exp;

  @override
  List<Object> get props => [exp];
}
