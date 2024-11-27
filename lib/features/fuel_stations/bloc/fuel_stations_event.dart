import 'package:equatable/equatable.dart';

abstract class FuelStationsEvent extends Equatable {
  const FuelStationsEvent();

  @override
  List<Object> get props => [];
}

final class FuelStationsEventUpgrade extends FuelStationsEvent {
  final String id;
  const FuelStationsEventUpgrade(this.id);

  @override
  List<Object> get props => [id];
}

final class FuelStationsEventRefillVehicle extends FuelStationsEvent {
  final String id;
  final double amount;
  const FuelStationsEventRefillVehicle(this.id, this.amount);

  @override
  List<Object> get props => [id, amount];
}

final class FuelStationsEventAddFuel extends FuelStationsEvent {
  final String id;
  final double amount;
  const FuelStationsEventAddFuel(this.id, this.amount);

  @override
  List<Object> get props => [id, amount];
}
